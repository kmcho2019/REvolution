module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pipeline register for shift control
reg [1:0] amount_reg;
wire shift_active = ena & ~load;
wire clk_en = load | ena;

always @(posedge clk) begin
    if (shift_active) amount_reg <= amount;
end

// Pre-compute sign bit for arithmetic shifts
wire sign_bit = q[63];

// Unified barrel shifter implementation
wire [63:0] shifted_value;
assign shifted_value = 
    (amount_reg == 2'b00) ? {q[62:0], 1'b0} :               // left 1
    (amount_reg == 2'b01) ? {q[55:0], 8'b0} :               // left 8
    (amount_reg == 2'b10) ? {sign_bit, q[63:1]} :           // right 1
                            {{8{sign_bit}}, q[63:8]};       // right 8

// Clock-gated register update
always @(posedge clk) begin
    if (clk_en) begin
        if (load) q <= data;
        else if (ena) q <= shifted_value;
    end
end

endmodule