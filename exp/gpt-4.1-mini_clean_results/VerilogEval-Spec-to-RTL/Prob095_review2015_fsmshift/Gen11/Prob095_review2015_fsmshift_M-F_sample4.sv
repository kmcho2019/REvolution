module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] counter;       // Counts down 4 cycles of shift_ena
    reg reset_d;             // Delayed reset for edge detection

    always @(posedge clk) begin
        reset_d <= reset;    // Sample reset to detect deassertion edge

        if (reset) begin
            // During synchronous reset, clear counter and shift_ena
            counter   <= 3'd0;
            shift_ena <= 1'b0;
        end else begin
            // On reset deassertion (reset_d==1 and reset==0), load counter to 4
            if (reset_d && !reset) begin
                counter   <= 3'd4;
                shift_ena <= 1'b1;
            end else if (counter != 3'd0) begin
                // While counter > 0, continue asserting shift_ena and decrement counter
                counter   <= counter - 3'd1;
                shift_ena <= 1'b1;
            end else begin
                // After 4 cycles, keep shift_ena deasserted
                shift_ena <= 1'b0;
            end
        end
    end

endmodule