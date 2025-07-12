module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;  // 2-bit down-counter (3→0)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;  // Initialize to 3 on reset
        end else if (counter != 2'b00) begin
            counter <= counter - 1;  // Decrement until 0
        end
    end

    assign shift_ena = (counter != 2'b00);  // Active when counter is non-zero

endmodule