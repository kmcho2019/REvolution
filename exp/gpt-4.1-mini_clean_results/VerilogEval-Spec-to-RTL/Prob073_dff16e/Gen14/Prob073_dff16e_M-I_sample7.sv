module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

reg [15:0] q_reg;

wire [15:0] d_next;

// For each byte, select new input if byteena set, else keep old data
assign d_next[15:8] = byteena[1] ? d[15:8] : q_reg[15:8];
assign d_next[7:0]  = byteena[0] ? d[7:0]  : q_reg[7:0];

always @(posedge clk) begin
    if (!resetn) begin
        q_reg <= 16'b0;
    end else begin
        q_reg <= d_next;
    end
end

assign q = q_reg;

endmodule