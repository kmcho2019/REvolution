module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

// Pipeline registers
reg [1:0] amount_reg;
reg shift_right_reg;
reg [7:0] sign_ext_reg;

// Internal register with clock gating
reg [63:0] shift_reg;
wire clk_en = load | ena;

// Control signals
wire do_load = load;
wire do_shift = ena & ~load;

// Stage 1: Pre-decode shift amount
always @(posedge clk) begin
    amount_reg <= amount;
    shift_right_reg <= amount[1];
    if (amount[1]) begin  // Only compute sign extension for right shifts
        sign_ext_reg <= {8{shift_reg[63]}};
    end
end

// Stage 2: Shift operations
wire [63:0] shift_result;
always @(*) begin
    if (shift_right_reg) begin
        shift_result = amount_reg[0] ? {sign_ext_reg, shift_reg[63:8]} : 
                                        {shift_reg[63], shift_reg[63:1]};
    end else begin
        shift_result = amount_reg[0] ? {shift_reg[55:0], 8'b0} : 
                                        {shift_reg[62:0], 1'b0};
    end
end

// Register update with clock gating
always @(posedge clk) begin
    if (clk_en) begin
        shift_reg <= do_load ? data : shift_result;
    end
end

// Output assignment
assign q = shift_reg;

endmodule