module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        ZOUT = 2'b10
    } state_t;

    state_t state, next_state;
    reg [1:0] cycle_count;   // counts 0..2 for 3 cycles
    reg [1:0] w_count;       // counts number of w=1 occurrences in current 3 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            case(state)
                A: begin
                    z <= 0;
                    cycle_count <= 0;
                    w_count <= 0;
                end
                B: begin
                    z <= 0;
                    if (w)
                        w_count <= w_count + 1;
                    else
                        w_count <= w_count;
                    cycle_count <= cycle_count + 1;
                end
                ZOUT: begin
                    // output z according to w_count
                    z <= (w_count == 2) ? 1'b1 : 1'b0;
                    cycle_count <= 0;
                    w_count <= 0;
                end
            endcase
        end
    end

    // next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (cycle_count == 2)  // done 3 cycles (count 0,1,2)
                    next_state = ZOUT;
                else
                    next_state = B;
            end
            ZOUT: begin
                next_state = B; // after outputting z, restart counting next 3 cycles
            end
            default: next_state = A;
        endcase
    end

endmodule