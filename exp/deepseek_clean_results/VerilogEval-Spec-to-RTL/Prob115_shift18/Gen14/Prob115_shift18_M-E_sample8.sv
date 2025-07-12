module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift control signals
wire shift_left = ~amount[1];
wire shift_1bit = ~amount[0];
wire shift_right = amount[1];

// Sign extension mask for right shifts (generated only when needed)
wire [63:0] sign_mask = {64{q[63]}};

// Pre-compute all possible shift results
wire [63:0] left_1 = {q[62:0], 1'b0};
wire [63:0] left_8 = {q[55:0], 8'b0};
wire [63:0] right_1 = {sign_mask[0], q[63:1]};
wire [63:0] right_8 = {sign_mask[7:0], q[63:8]};

// Hierarchical shift selection
wire [63:0] left_shift = shift_1bit ? left_1 : left_8;
wire [63:0] right_shift = shift_1bit ? right_1 : right_8;
wire [63:0] next_q = shift_left ? left_shift : right_shift;

// Clocked update with enable gating
always @(posedge clk) begin
    case ({load, ena})
        2'b10: q <= data;        // Load has priority
        2'b01: q <= next_q;     // Shift when enabled
        default: q <= q;        // Hold value otherwise
    endcase
end

endmodule