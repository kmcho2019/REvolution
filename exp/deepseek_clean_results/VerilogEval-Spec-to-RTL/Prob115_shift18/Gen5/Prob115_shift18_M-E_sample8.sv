module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pipeline stage 1 registers
reg [1:0] amount_reg;
reg load_reg;
reg ena_reg;
reg [63:0] data_reg;

// Shift control signals
wire shift_left = ~amount_reg[1];
wire shift_8bits = amount_reg[0];
wire shift_right = amount_reg[1];

// Dynamic sign extension (only computed when needed)
wire sign_bit = q[63] & shift_right;

// Shift operations (computed in parallel)
wire [63:0] shift_left_val = shift_8bits ? {q[55:0], 8'b0} : {q[62:0], 1'b0};
wire [63:0] shift_right_val = shift_8bits ? {{8{sign_bit}}, q[63:8]} : {sign_bit, q[63:1]};

// Next state logic
wire [63:0] next_q = shift_left ? shift_left_val : shift_right_val;

// Pipeline stage 1: Capture inputs
always @(posedge clk) begin
    amount_reg <= amount;
    load_reg <= load;
    ena_reg <= ena;
    data_reg <= data;
end

// Pipeline stage 2: Execute operation
always @(posedge clk) begin
    if (load_reg) begin
        q <= data_reg;
    end else if (ena_reg) begin
        q <= next_q;
    end
end

endmodule