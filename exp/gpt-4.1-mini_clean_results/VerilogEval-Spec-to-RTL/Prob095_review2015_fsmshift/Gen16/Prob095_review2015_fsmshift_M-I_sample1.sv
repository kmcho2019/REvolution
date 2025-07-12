module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter; // 3 bits to count from 4 down to 0

    always @(posedge clk) begin
        if (reset) begin
            // Load counter to 4 on synchronous reset
            counter   <= 3'd4;
            shift_ena <= 1'b1;
        end else if (counter != 3'd0) begin
            // Count down while non-zero
            counter   <= counter - 1;
            // Keep shift_ena asserted
            shift_ena <= 1'b1;
        end else begin
            // Once counter reaches zero, deassert shift_ena forever
            shift_ena <= 1'b0;
            counter   <= 3'd0;
        end
    end

endmodule