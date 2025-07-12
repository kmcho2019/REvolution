module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;
assign feedback = out[3] ~^ out[2];  // XNOR of bits 3 and 2

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Active high reset to zero
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule