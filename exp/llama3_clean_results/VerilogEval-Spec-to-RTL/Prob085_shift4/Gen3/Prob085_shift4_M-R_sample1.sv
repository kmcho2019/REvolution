module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [3:0] q_next;

always @(*) begin
    case (1'b1)
        load: q_next = data;
        ena: q_next = {1'b0, q_reg[3:1]};
        default: q_next = q_reg;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

endmodule