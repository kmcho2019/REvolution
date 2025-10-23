module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Define the tap positions as parameters
parameter TAP1 = 4;
parameter TAP2 = 2;

// Define the initial state
initial q = 5'b10001;

// Internal signal to hold the current state
reg [4:0] q_int;

// Combinational logic to calculate the next state
always @(*) begin
    if (reset) begin
        q_int = 5'b10001;
    end else begin
        q_int = {q[TAP1] ^ q[TAP2], q[4:1]};
    end
end

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b10001;
    end else begin
        q <= q_int;
    end
end

endmodule