module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] q_next;

assign q_next = (load) ? data : (ena) ? {1'b0, q_reg[3:1]} : q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

endmodule