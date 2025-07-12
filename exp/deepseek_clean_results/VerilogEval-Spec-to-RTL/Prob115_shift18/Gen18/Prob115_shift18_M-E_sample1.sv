module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Parameters for shift amounts
localparam SHIFT_1 = 1'b0;
localparam SHIFT_8 = 1'b1;

// Internal signals
wire [63:0] next_q;
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_amt = amount[0];

// Shift computation logic
assign next_q = load ? data : 
               do_shift ? (shift_right ? 
                          (shift_amt ? 
                           {{8{q[63]}}, q[63:8]} :  // Right shift by 8
                           {q[63], q[63:1]}        // Right shift by 1
                          ) : 
                          (shift_amt ? 
                           {q[55:0], 8'b0} :       // Left shift by 8
                           {q[62:0], 1'b0}         // Left shift by 1
                          )
               ) : q;

// Clocked register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule