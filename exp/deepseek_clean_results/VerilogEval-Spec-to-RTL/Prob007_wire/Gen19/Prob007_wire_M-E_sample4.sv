module TopModule (
    input wire in,
    output reg out,
    input wire clk
);
    always @(posedge clk) begin
        out <= in;
    end
endmodule