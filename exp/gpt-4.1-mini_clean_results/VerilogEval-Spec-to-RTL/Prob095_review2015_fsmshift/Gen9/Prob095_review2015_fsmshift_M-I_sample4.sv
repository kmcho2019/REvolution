module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // Assert shift_ena on reset cycle and set counter for 3 more cycles
            shift_ena <= 1'b1;
            counter <= 3'd3;
        end else if (counter != 3'd0) begin
            // Keep shift_ena asserted while counter is nonzero, decrement counter
            shift_ena <= 1'b1;
            counter <= counter - 3'd1;
        end else begin
            // After 4 cycles, deassert shift_ena forever until next reset
            shift_ena <= 1'b0;
        end
    end

endmodule