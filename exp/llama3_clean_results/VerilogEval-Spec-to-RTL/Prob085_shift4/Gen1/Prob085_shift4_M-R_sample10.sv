module TopModule (
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [3:0] next_q;

always @(posedge areset) begin
    q_reg <= 4'b0;
end

always @(*) begin
    if (load) begin
        next_q = data;
    end else if (ena) begin
        next_q = {1'b0, q_reg[3:1]};
    end else begin
        next_q = q_reg;
    end
end

always @(posedge clk) begin
    if (!areset) begin
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule