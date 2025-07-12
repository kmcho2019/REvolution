module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // Counter counts down from 3 to 0 (4 cycles total)
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11;  // Initialize to 3 (binary 11)
        end else if (counter != 2'b00) begin
            counter <= counter - 1'b1;  // Decrement until 0
        end
    end

    // shift_ena is high when counter is not zero
    assign shift_ena = (counter != 2'b00);

endmodule