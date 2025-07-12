module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift control signals
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Continuous shift logic
wire [63:0] shift_result = 
    shift_right ? 
        (shift_8 ? {{8{q[63]}}, q[63:8]} : {q[63], q[63:1]}) :
        (shift_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0});

// Next value calculation (load takes priority)
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule