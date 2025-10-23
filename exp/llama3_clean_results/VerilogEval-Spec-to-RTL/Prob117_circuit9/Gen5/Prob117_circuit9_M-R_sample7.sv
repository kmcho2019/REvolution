module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the next state logic
reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 4; // Next state is 4 when a is high
    end else if (q < 6) begin
        next_q = q + 1; // Next state is current state + 1 when a is low and q < 6
    end else begin
        next_q = 0; // Next state wraps around to 0 when q reaches 6
    end
end

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    q <= next_q;
end

// Initialize the output
initial q = 4;

endmodule