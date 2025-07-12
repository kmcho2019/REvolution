module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

// Internal signals and registers
reg [63:0] q_reg;
wire [63:0] next_q;

// Barrel shifter for left shifts
wire [63:0] left_shift_1 = {q_reg[62:0], 1'b0};
wire [63:0] left_shift_8 = {q_reg[55:0], 8'd0};

// Arithmetic right shift module
wire [63:0] right_shift_1 = {q_reg[63], q_reg[63:1]};
wire [63:0] right_shift_8 = {{8{q_reg[63]}}, q_reg[63:8]};

// Combinational logic to determine the next state
assign next_q = (load) ? data :
                (ena) ?
                    (amount == 2'b00) ? left_shift_1 :
                    (amount == 2'b01) ? left_shift_8 :
                    (amount == 2'b10) ? right_shift_1 :
                    (amount == 2'b11) ? right_shift_8 :
                    q_reg
                : q_reg;

// Sequential logic to update the state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= next_q;
    end else begin
        q_reg <= q_reg;
    end
end

// Output assignment
assign q = q_reg;

endmodule