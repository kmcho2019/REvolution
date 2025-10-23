module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;  // Only need 2 bits (counts 3→2→1→0)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;  // Initialize to 3 (for 4 cycles)
        end else if (counter != 2'b00) begin
            counter <= counter - 1'b1;
        end
    end

    assign shift_ena = (counter != 2'b00);  // Assert when counter is non-zero

endmodule