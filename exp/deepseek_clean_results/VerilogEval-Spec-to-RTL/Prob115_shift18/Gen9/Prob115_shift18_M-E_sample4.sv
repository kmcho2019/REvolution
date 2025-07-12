module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

// Hierarchical shift selection
wire [63:0] shift_result;
assign shift_result = (amount == 2'b00) ? shift_left_1 :
                     (amount == 2'b01) ? shift_left_8 :
                     (amount == 2'b10) ? shift_right_1 :
                     shift_right_8;

// State update logic
always @(posedge clk) begin
    case ({load, ena})
        2'b10: q <= data;       // Load has priority
        2'b01: q <= shift_result; // Shift when enabled
        default: q <= q;        // Hold value otherwise
    endcase
end

endmodule