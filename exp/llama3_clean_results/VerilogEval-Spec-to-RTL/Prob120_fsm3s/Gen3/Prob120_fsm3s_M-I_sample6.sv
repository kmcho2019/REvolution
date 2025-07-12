`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] state, next_state;

// Initialize the state to A
initial state = 4'b0001;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always @(*) begin
    case (1'b1)
        state[0]: begin // State A
            next_state = in ? 4'b0010 : 4'b0001;
            out = 0;
        end
        state[1]: begin // State B
            next_state = in ? 4'b0010 : 4'b0100;
            out = 0;
        end
        state[2]: begin // State C
            next_state = in ? 4'b1000 : 4'b0001;
            out = 0;
        end
        state[3]: begin // State D
            next_state = in ? 4'b0010 : 4'b0100;
            out = 1;
        end
    endcase
end

endmodule