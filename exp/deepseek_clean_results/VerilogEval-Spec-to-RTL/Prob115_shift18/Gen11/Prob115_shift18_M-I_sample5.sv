module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Clock gating logic
wire clk_en = load | ena;
wire gated_clk = clk & clk_en;

// Enable-gated control signals
wire shift_left = ena ? ~amount[1] : 1'b0;
wire shift_by_8 = ena ? amount[0] : 1'b0;

// Shared sign extension logic
wire sign_bit = q[63];
wire [7:0] sign_byte = {8{sign_bit}};

// Pipeline stage 1: Shift direction selection
reg [63:0] stage1_shift;
always @(*) begin
    if (shift_left) begin
        stage1_shift = q;
    end else begin
        // Pre-compute arithmetic right shift components
        stage1_shift = {sign_bit, q[63:1]}; // Default 1-bit shift
    end
end

// Pipeline stage 2: Shift amount selection
wire [63:0] shifted_val;
assign shifted_val = shift_by_8 ? 
                    (shift_left ? (stage1_shift << 8) : {sign_byte, stage1_shift[63:8]}) :
                    (shift_left ? (stage1_shift << 1) : stage1_shift);

// Next state logic with load priority
wire [63:0] next_q = load ? data : shifted_val;

// Register update with gated clock
always @(posedge gated_clk) begin
    if (clk_en) begin
        q <= next_q;
    end
end

endmodule