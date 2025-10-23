module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [3:0] cnt;  // Counter, assuming 4 bits is sufficient for common division factors
reg error;      // Flag to indicate if NUM_DIV is not even

// Check if NUM_DIV is even at the beginning of the simulation
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be an even number.");
        error = 1'b1;
    end else begin
        error = 1'b0;
    end
end

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else if (error) begin
        // If NUM_DIV is not even, set clk_div to 0
        clk_div <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 0;
        clk_div <= ~clk_div;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule