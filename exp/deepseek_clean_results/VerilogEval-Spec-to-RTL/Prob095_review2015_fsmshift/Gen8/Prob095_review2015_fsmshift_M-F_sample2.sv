module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b100; // Initialize to 4 (for 4 cycles)
            shift_ena <= 1'b1;  // Assert immediately on reset
        end else begin
            if (counter != 3'b000) begin
                counter <= counter - 1'b1;
                shift_ena <= 1'b1; // Keep asserted while counting
            end else begin
                shift_ena <= 1'b0; // Deassert after count completes
            end
        end
    end

endmodule