module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output wire q
);

wire q_next;
reg q_ff = 1'b0;

// Combinational logic for next state
assign q_next = ar ? 1'b0 : d;

// Clock edge detection and state update
always @(posedge clk or posedge ar) begin
    q_ff <= q_next;
end

assign q = q_ff;

endmodule