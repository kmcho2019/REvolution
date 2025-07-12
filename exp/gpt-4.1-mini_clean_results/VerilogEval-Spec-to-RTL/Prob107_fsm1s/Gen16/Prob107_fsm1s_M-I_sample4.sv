module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for B state
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0)
                        state <= A;
                    else
                        state <= B;
                    out <= 1'b1; // B state's output
                end
                A: begin
                    if (in == 1'b0)
                        state <= B;
                    else
                        state <= A;
                    out <= 1'b0; // A state's output
                end
                default: begin
                    state <= B;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule