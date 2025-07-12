// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// State encoding: S0 (00), S1 (01), S2 (10)
reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    // If reset is active, initialize the state machine
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        // State transitions
        case (state)
            2'b00: begin
                if (x) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (!x) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                if (x) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b10;
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

// Output logic: Assert z when the state machine is in S2 and the current input is "1"
assign z = (state == 2'b10) && x;

endmodule