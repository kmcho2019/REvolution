module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
wire [63:0] shift_left_1;
wire [63:0] shift_left_8;
wire [63:0] shift_right_1;
wire [63:0] shift_right_8;
wire [63:0] shifted_value;
wire [63:0] next_q;

// Pre-compute all possible shift operations
assign shift_left_1 = {q[62:0], 1'b0};
assign shift_left_8 = {q[55:0], 8'b0};
assign shift_right_1 = {q[63], q[63:1]};
assign shift_right_8 = {{8{q[63]}}, q[63:8]};

// Select appropriate shift based on amount
assign shifted_value = (ena) ? 
                      (amount == 2'b00) ? shift_left_1 :
                      (amount == 2'b01) ? shift_left_8 :
                      (amount == 2'b10) ? shift_right_1 :
                      shift_right_8 : q;

// Load has priority over shifting
assign next_q = load ? data : shifted_value;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule