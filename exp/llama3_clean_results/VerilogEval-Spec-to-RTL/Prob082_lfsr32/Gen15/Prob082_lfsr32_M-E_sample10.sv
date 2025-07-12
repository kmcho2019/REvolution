module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] q_next;

integer i;
reg feedback;

// Combinational logic to calculate the feedback term
always @(*) begin
    feedback = 1'b0;
    feedback = feedback ^ q[0]; // Tap at position 1
    feedback = feedback ^ q[21]; // Tap at position 22
    feedback = feedback ^ q[30]; // Tap at position 31
end

// Combinational logic to shift the register to the right and apply the feedback term
always @(*) begin
    q_next = {feedback, q[31:1]};
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q <= q_next; // Update state register
    end
end

endmodule