module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results in parallel
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// Create shift selection mask
wire [1:0] shift_sel = (load) ? 2'b00 :  // Load has highest priority
                       (~ena) ? 2'b00 :  // No shift if not enabled
                       (amount == 2'b00) ? 2'b01 :  // Left 1
                       (amount == 2'b01) ? 2'b10 :  // Left 8
                       (amount == 2'b10) ? 2'b11 :  // Right 1
                       2'b100;                     // Right 8

// Final shift selection using efficient multiplexer
wire [63:0] next_q = 
    (shift_sel == 2'b00) ? data :          // Load case
    (shift_sel == 2'b01) ? shift_left_1 :  // Left 1
    (shift_sel == 2'b10) ? shift_left_8 :  // Left 8
    (shift_sel == 2'b11) ? shift_right_1 : // Right 1
    shift_right_8;                         // Right 8

// Clock-gated register update
always @(posedge clk) begin
    if (load || ena) begin
        q <= next_q;
    end
end

endmodule