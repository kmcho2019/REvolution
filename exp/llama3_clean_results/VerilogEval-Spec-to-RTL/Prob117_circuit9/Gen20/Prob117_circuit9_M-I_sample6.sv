module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states of the FSM
reg [2:0] state;

// Initialize the state
initial state = 4;

// Update the state at every positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        state <= 4;
    end else if (state == 4) begin
        state <= 5;
    end else if (state == 5) begin
        state <= 6;
    end else if (state == 6) begin
        state <= 0;
    end else if (state == 0) begin
        state <= 1;
    end else if (state == 1) begin
        state <= 2;
    end else if (state == 2) begin
        state <= 3;
    end else if (state == 3) begin
        state <= 4;
    end
end

// Assign the output q to the current state
assign q = state;

endmodule