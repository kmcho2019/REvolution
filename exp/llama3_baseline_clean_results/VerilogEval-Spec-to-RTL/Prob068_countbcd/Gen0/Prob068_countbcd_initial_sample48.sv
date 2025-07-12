module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] q_reg;
wire [15:0] q_next;

assign q = q_reg;
assign q_next = {
    (q_reg[11:8] + 1) & 9'b10011, // Thousands place
    (q_reg[7:4] + ena[2]) & 9'b10011, // Hundreds place
    (q_reg[3:0] + ena[1]) & 9'b10011  // Tens place
};

always @(*) begin
    case(q_reg[3:0])
        9'b1001: ena[0] = 1'b1; // Ones place
        default: ena[0] = 1'b0;
    endcase
    case(q_reg[7:4])
        9'b1001: ena[1] = 1'b1; // Tens place
        default: ena[1] = 1'b0;
    endcase
    case(q_reg[11:8])
        9'b1001: ena[2] = 1'b1; // Hundreds place
        default: ena[2] = 1'b0;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        q_reg <= 16'd0;
    end else begin
        q_reg <= q_next;
    end
end

endmodule