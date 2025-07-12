module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    // Use a signed 3-bit counter to allow -1 value for end condition
    reg signed [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, start enabling shift_ena for 4 cycles
            counter <= 3'sd3;   // counts: 3,2,1,0 -> 4 cycles
            shift_ena <= 1'b1;
        end else if (counter >= 0) begin
            // Decrement counter while >= 0, keep shift_ena asserted
            counter <= counter - 1;
            shift_ena <= 1'b1;
        end else begin
            // After counting down, keep shift_ena low
            shift_ena <= 1'b0;
        end
    end

endmodule