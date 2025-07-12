module freq_diveven #(
    parameter NUM_DIV = 10 // Must be an even number
)(
    input  clk,        // Input clock signal
    input  rst_n,      // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

localparam CNT_WIDTH = $clog2(NUM_DIV / 2); // Calculate the required width for the counter

reg [CNT_WIDTH-1:0] cnt; // Counter register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= '0;    // Reset the counter
        clk_div <= 1'b0; // Reset the divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin // If the counter is less than half of NUM_DIV - 1
            cnt <= cnt + 1; // Increment the counter
        end else begin // When the counter reaches the specified limit
            cnt <= '0; // Reset the counter
            clk_div <= ~clk_div; // Toggle the divided clock output
        end
    end
end

endmodule