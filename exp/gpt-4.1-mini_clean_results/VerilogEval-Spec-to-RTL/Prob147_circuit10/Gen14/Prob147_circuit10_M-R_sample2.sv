module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Compute next_state combinationally
always @(*) begin
    next_state = (state & ~(a & b)) | (b & ~a);
end

// Update state on clock rising edge
always @(posedge clk) begin
    state <= next_state;
end

// Combinational output logic
assign q = (state & ~a) | (~state & b);

// Initialize state to zero
initial begin
    state = 1'b0;
end

endmodule