// BCD Digit Counter Module
module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output wrap
);

reg [3:0] q_reg;
assign q = q_reg;
assign wrap = (q_reg == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'd0;
    end else if (ena) begin
        if (q_reg == 4'd9) begin
            q_reg <= 4'd0;
        end else begin
            q_reg <= q_reg + 1;
        end
    end
end

endmodule

// Top Module
module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// instantiate BCD counters
BCD_Counter ones(.clk(clk), .reset(reset), .ena(1'b1), .q(q[3:0]), .wrap(ena[0]));
BCD_Counter tens(.clk(clk), .reset(reset), .ena(ena[0]), .q(q[7:4]), .wrap(ena[1]));
BCD_Counter hundreds(.clk(clk), .reset(reset), .ena(ena[1]), .q(q[11:8]), .wrap(ena[2]));
BCD_Counter thousands(.clk(clk), .reset(reset), .ena(ena[2]), .q(q[15:12]));

endmodule