module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

reg [7:0] q_upper, q_lower;

wire [7:0] mask_upper = {8{byteena[1]}};
wire [7:0] mask_lower = {8{byteena[0]}};

always @(posedge clk) begin
    if (!resetn) begin
        q_upper <= 8'b0;
        q_lower <= 8'b0;
    end else begin
        q_upper <= (q_upper & ~mask_upper) | (d[15:8] & mask_upper);
        q_lower <= (q_lower & ~mask_lower) | (d[7:0] & mask_lower);
    end
end

assign q = {q_upper, q_lower};

endmodule