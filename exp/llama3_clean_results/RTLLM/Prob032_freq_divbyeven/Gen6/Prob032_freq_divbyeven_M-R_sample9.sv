// Refactored module for frequency division by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2!= 0 || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number greater than 1.");
        $finish;
    end
end

reg [1:0] state;  // State variable for state machine
reg [$clog2(NUM_DIV)-1:0] cnt;  // Counter to track clock cycles

// State machine for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and counter when reset is asserted
        state <= 2'b00;
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (cnt == (NUM_DIV / 2 - 1)) begin
                    state <= 2'b01;
                    cnt <= '0;
                    clk_div <= ~clk_div;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            2'b01: begin
                if (cnt == (NUM_DIV / 2 - 1)) begin
                    state <= 2'b00;
                    cnt <= '0;
                    clk_div <= ~clk_div;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            default: begin
                state <= 2'b00;
                cnt <= '0;
                clk_div <= 1'b0;
            end
        endcase
    end
end

endmodule