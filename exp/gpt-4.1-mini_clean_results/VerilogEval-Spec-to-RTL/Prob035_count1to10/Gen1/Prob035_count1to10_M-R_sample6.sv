module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// State register representing the current count (1 to 10)
reg [3:0] state, next_state;

// Combinational logic to compute next state
always @(*) begin
    if (state == 4'd10)
        next_state = 4'd1;
    else
        next_state = state + 4'd1;
end

// Sequential logic for state update with synchronous reset
always @(posedge clk) begin
    if (reset)
        state <= 4'd1;
    else
        state <= next_state;
end

// Output assignment
always @(posedge clk) begin
    q <= state;
end

endmodule