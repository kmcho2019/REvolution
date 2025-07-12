module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pipeline registers
reg [63:0] shift_stage1;
reg [1:0] amount_reg;
reg do_shift_reg;
reg sign_bit;

// Stage 1: Decode and prepare
always @(posedge clk) begin
    if (load) begin
        shift_stage1 <= data;
        sign_bit <= data[63];
        do_shift_reg <= 1'b0;
    end else if (ena) begin
        shift_stage1 <= q;
        sign_bit <= q[63];
        amount_reg <= amount;
        do_shift_reg <= 1'b1;
    end else begin
        do_shift_reg <= 1'b0;
    end
end

// Stage 2: Execute shift
wire [63:0] shift_result;
assign shift_result = 
    (!do_shift_reg) ? shift_stage1 :
    (amount_reg == 2'b00) ? {shift_stage1[62:0], 1'b0} :         // Left 1
    (amount_reg == 2'b01) ? {shift_stage1[55:0], 8'b0} :         // Left 8
    (amount_reg == 2'b10) ? {sign_bit, shift_stage1[63:1]} :     // Right 1
    { {8{sign_bit}}, shift_stage1[63:8] };                       // Right 8

// Output register with clock gating
always @(posedge clk) begin
    if (load || do_shift_reg) begin
        q <= shift_result;
    end
end

endmodule