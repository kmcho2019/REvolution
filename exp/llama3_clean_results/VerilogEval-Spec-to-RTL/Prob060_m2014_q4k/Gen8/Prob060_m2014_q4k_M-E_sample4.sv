// Wide Register Module with Active-Low Synchronous Reset
module WideRegister(
    input clk,
    input resetn,
    input in,
    output [3:0] q
);

reg [3:0] q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (!resetn) begin
        q_reg <= 4'b0000;
    end else begin
        q_reg <= {q_reg[2:0], in};
    end
end

endmodule

// TopModule with Wide Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

wire [3:0] q;

WideRegister reg(clk, resetn, in, q);

assign out = q[3];

endmodule