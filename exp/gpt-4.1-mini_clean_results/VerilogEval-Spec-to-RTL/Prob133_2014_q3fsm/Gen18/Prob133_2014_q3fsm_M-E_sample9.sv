module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [1:0] {A=2'b00, B=2'b01, C=2'b10} state_t;
    state_t state, next_state;

    reg [1:0] w_count;
    reg [1:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            state       <= A;
            w_count     <= 2'd0;
            cycle_count <= 2'd0;
            z           <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    z <= 1'b0;
                    w_count <= 2'd0;
                    cycle_count <= 2'd0;
                end

                B: begin
                    w_count <= w_count + w;
                    cycle_count <= cycle_count + 1;
                    z <= 1'b0;
                end

                C: begin
                    w_count <= w_count + w;
                    cycle_count <= cycle_count + 1;
                    // On cycle 3, determine z
                    z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                end

                default: begin
                    w_count <= 2'd0;
                    cycle_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                if (cycle_count == 2'd1)
                    next_state = C;
                else
                    next_state = B;
            end

            C: begin
                if (cycle_count == 2'd2)
                    next_state = B;
                else
                    next_state = C;
            end

            default: next_state = A;
        endcase
    end

endmodule