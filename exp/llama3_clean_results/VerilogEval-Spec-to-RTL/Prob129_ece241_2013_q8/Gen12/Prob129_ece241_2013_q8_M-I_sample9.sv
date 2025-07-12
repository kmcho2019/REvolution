// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// State machine states
reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    // If reset is active, initialize the state machine
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        // State machine logic
        case (state)
            2'b00: state <= x ? 2'b01 : 2'b00;
            2'b01: state <= x ? 2'b10 : 2'b00;
            2'b10: state <= x ? 2'b10 : 2'b01;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic: Assert z when the state machine is in the final state and the input is 1
assign z = (state == 2'b10) && x;

endmodule