module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        A  = 2'd0,
        B0 = 2'd1,
        B1 = 2'd2,
        B2 = 2'd3
    } state_t;

    state_t state, next_state;

    reg [1:0] w_count; // count of w=1 in current 3-cycle window

    // Sequential logic: state, w_count, z update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
                B0: begin
                    // start counting w in first cycle
                    w_count <= (w) ? 2'd1 : 2'd0;
                    z <= 1'b0;
                end
                B1: begin
                    // count second cycle
                    w_count <= w_count + (w ? 2'd1 : 2'd0);
                    z <= 1'b0;
                end
                B2: begin
                    // count third cycle
                    w_count <= 2'd0; // reset counter for next window
                    // output z=1 if exactly two w=1's in last 3 cycles
                    z <= (w_count + (w ? 2'd1 : 2'd0) == 2);
                end
                default: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic: next state
    always @(*) begin
        case (state)
            A: next_state = (s) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule