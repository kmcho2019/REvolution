module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    typedef enum logic {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;  // output for state B
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0)
                        state <= A;
                    else
                        state <= B;
                    out <= 1'b1;  // output for state B
                end
                A: begin
                    if (in == 1'b0)
                        state <= B;
                    else
                        state <= A;
                    out <= 1'b0;  // output for state A
                end
                default: begin
                    state <= B;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule