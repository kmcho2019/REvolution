module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Temporary storage for flip-flop outputs before reset
wire [7:0] q_ff;

// Flip-flop implementation using clock edge detection
assign q_ff = $past(d, 1, 8'b0, posedge clk);

// Apply synchronous reset
assign q = reset ? 8'b0 : q_ff;

endmodule