module TopModule(
    input clk,
    input a,
    output reg q
);

// Use a single flip-flop to store the state
reg state;

// Initial state
initial state = 1'b1;

// State transition logic using a simple conditional statement
always @(posedge clk) begin
    state <=!a;
end

// Assign output q based on current state
assign q = state;

endmodule