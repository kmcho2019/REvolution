module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, start enabling shift_ena for 4 cycles
            counter <= 3'd4;
            shift_ena <= 1'b1;
        end else if (counter != 0) begin
            // Decrement counter and keep shift_ena high while counting down
            counter <= counter - 1;
            shift_ena <= 1'b1;
        end else begin
            // After 4 cycles, keep shift_ena low indefinitely until next reset
            shift_ena <= 1'b0;
        end
    end

endmodule