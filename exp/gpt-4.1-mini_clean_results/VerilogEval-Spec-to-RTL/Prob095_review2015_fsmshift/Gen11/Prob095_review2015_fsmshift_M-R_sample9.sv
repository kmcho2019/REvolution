module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] count;

    // Synchronous reset and counting logic
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;       // Load 4 on reset
        end else if (count != 0) begin
            count <= count - 1;  // Count down while non-zero
        end
    end

    // Output asserted while count is non-zero (exactly 4 cycles after reset)
    assign shift_ena = (count != 0);

endmodule