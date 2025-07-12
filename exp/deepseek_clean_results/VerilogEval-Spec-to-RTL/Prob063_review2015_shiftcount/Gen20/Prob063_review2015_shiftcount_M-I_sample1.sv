module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Optimized decrement logic using carry chain
wire [3:0] decremented = q - 1'b1;

// Next state logic
assign next_q = shift_ena ? {q[2:0], data} : 
               count_ena ? decremented : 
               q;  // Explicit hold state

always @(posedge clk) begin
    q <= next_q;
end

endmodule