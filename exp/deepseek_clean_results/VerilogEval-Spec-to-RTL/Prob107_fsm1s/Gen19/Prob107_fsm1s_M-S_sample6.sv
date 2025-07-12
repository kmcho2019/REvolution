module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b1;
        end else begin
            out <= out ^ ~in;
        end
    end

endmodule