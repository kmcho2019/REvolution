module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Efficient control signal decoding
wire do_shift = ena & ~load;
wire shift_left = ~amount[1];
wire [6:0] shift_amount = amount[0] ? 3'd8 : 3'd1;

// Optimized shift operations - only compute when needed
wire [63:0] shifted_value;
assign shifted_value = shift_left ? 
                      (q << shift_amount) :                // Left shift
                      ({ {shift_amount{q[63]}}, q[63:shift_amount] });  // Arithmetic right shift

// Next state logic with minimal muxing
wire [63:0] next_q = load ? data : (do_shift ? shifted_value : q);

// Register update with implicit clock gating
always @(posedge clk) begin
    q <= next_q;
end

endmodule