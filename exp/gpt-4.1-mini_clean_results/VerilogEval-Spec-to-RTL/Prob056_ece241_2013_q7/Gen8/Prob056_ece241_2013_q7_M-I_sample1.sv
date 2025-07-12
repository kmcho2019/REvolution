module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

assign nextQ = (~k & (j | Q)) | (j & k & ~Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule