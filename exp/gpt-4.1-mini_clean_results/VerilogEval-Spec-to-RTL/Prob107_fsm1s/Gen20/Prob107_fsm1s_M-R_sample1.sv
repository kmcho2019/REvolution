module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0, A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            case (state)
                B: begin
                    out <= 1'b1;
                    if (in == 1'b0)
                        state <= A;
                    else
                        state <= B;
                end
                A: begin
                    out <= 1'b0;
                    if (in == 1'b0)
                        state <= B;
                    else
                        state <= A;
                end
                default: begin
                    state <= B;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule