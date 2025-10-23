module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Control unit to determine shift operation
wire [1:0] shift_amount;
wire shift_left;
wire shift_right;

assign shift_amount = amount;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);

// Shift logic
wire [63:0] shifted_q;
assign shifted_q = (shift_left)? 
                   (amount == 2'b00)? {q_reg[62:0], 1'b0} : 
                   (amount == 2'b01)? {q_reg[55:0], 8'd0} : 
                   q_reg : 
                   (shift_right)? 
                   (amount == 2'b10)? {q_reg[63], q_reg[63:1]} : 
                   (amount == 2'b11)? {{8{q_reg[63]}}, q_reg[63:8]} : 
                   q_reg : 
                   q_reg;

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= shifted_q;
    end
end

assign q = q_reg;

endmodule