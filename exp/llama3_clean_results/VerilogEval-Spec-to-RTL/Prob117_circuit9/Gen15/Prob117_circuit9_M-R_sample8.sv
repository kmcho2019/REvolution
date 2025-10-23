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
    case(state)
        0: state <= (a) ? 4 : 1;
        1: state <= (a) ? 4 : 2;
        2: state <= (a) ? 4 : 3;
        3: state <= (a) ? 4 : 4;
        4: state <= (a) ? 4 : 5;
        5: state <= (a) ? 4 : 6;
        6: state <= (a) ? 4 : 0;
        default: state <= 4;
    endcase
end

// Assign the output q to the current state
assign q = state;

endmodule