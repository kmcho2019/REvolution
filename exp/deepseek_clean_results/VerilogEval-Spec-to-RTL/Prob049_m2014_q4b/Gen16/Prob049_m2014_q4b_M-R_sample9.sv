module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

wire next_q;

// Combinational logic for next state
assign next_q = ar ? 1'b0 : d;

// Sequential state update
always @(posedge clk or posedge ar) begin
    q <= next_q;
end

endmodule