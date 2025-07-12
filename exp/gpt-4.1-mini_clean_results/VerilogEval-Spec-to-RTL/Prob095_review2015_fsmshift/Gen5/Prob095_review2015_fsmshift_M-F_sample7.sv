module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            // Start counting and assert shift_ena on reset
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else if (count < 3'd3) begin
            // Continue asserting shift_ena for cycles 1,2,3 after reset
            count <= count + 1;
            shift_ena <= 1'b1;
        end else begin
            // After 4 cycles total, deassert shift_ena and stop counting
            count <= 3'd4; // Hold count at 4 to prevent further increments
            shift_ena <= 1'b0;
        end
    end

endmodule