module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter;    // 3-bit counter for 4 cycles
    reg reset_d;          // delayed reset to detect falling edge of reset

    always @(posedge clk) begin
        reset_d <= reset;

        if (reset) begin
            counter <= 3'd0;  // Clear counter during reset
        end else if (reset_d && !reset) begin
            // Reset just deasserted: load counter to 4 cycles
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
        // else counter stays at 0
    end

    assign shift_ena = (counter != 0);

endmodule