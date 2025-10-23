module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state;       // 0 = A, 1 = B
reg next_state;

// Next state logic
always @(*) begin
    if (state == 1'b0) // A
        next_state = x ? 1'b1 : 1'b0;
    else               // B
        next_state = 1'b1;
end

// Output logic (Mealy)
always @(*) begin
    if (state == 1'b0) // A
        z = x ? 1'b1 : 1'b0;
    else               // B
        z = x ? 1'b0 : 1'b1;
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 1'b0; // Reset to A
    else
        state <= next_state;
end

endmodule