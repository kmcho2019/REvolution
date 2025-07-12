module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output reg  q
);

wire next_q;  // Next state value

// Combinational logic for next state
assign next_q = ar ? 1'b0 : d;

// Sequential logic (positive edge-triggered)
always @(posedge clk or posedge ar) begin
    q <= next_q;
end

endmodule