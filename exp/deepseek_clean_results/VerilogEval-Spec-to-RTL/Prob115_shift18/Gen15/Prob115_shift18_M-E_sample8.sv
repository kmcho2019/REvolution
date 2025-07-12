module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// One-hot amount decoding
wire shift_left_1  = (amount == 2'b00);
wire shift_left_8  = (amount == 2'b01);
wire shift_right_1 = (amount == 2'b10);
wire shift_right_8 = (amount == 2'b11);

// Pre-compute all possible shift results
wire [63:0] left_shift_1  = {q[62:0], 1'b0};
wire [63:0] left_shift_8  = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = $signed(q) >>> 1;
wire [63:0] right_shift_8 = $signed(q) >>> 8;

// Select shift result based on amount
reg [63:0] shifted_result;
always @(*) begin
    case (1'b1) // Synthesis will optimize this to parallel mux
        shift_left_1:  shifted_result = left_shift_1;
        shift_left_8:  shifted_result = left_shift_8;
        shift_right_1: shifted_result = right_shift_1;
        shift_right_8: shifted_result = right_shift_8;
        default:       shifted_result = q; // Shouldn't happen
    endcase
end

// Final output selection
wire [63:0] next_q = load ? data : (ena ? shifted_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule