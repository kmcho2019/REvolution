module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Parameters for shift amounts
parameter SHIFT_LEFT_1 = 2'b00;
parameter SHIFT_LEFT_8 = 2'b01;
parameter SHIFT_RIGHT_1 = 2'b10;
parameter SHIFT_RIGHT_8 = 2'b11;

wire [63:0] next_q;
reg [63:0] shifted_val;

// Shift amount decoding
always @(*) begin
    case (amount)
        SHIFT_LEFT_1:  shifted_val = {q[62:0], 1'b0};
        SHIFT_LEFT_8:  shifted_val = {q[55:0], 8'b0};
        SHIFT_RIGHT_1: shifted_val = {q[63], q[63:1]};
        SHIFT_RIGHT_8: shifted_val = {{8{q[63]}}, q[63:8]};
        default:       shifted_val = q;
    endcase
end

// Next state logic
assign next_q = load ? data : (ena ? shifted_val : q);

// Register update with enable gating
always @(posedge clk) begin
    if (load || ena) begin
        q <= next_q;
    end
end

endmodule