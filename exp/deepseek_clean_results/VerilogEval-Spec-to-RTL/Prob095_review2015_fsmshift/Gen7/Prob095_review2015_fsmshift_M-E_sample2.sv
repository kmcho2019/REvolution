module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b11; // Initialize to 3 (for 4 cycles)
        end else if (counter != 2'b00) begin
            counter <= counter - 1'b1;
        end
    end

    // Output is high when counter is not zero
    assign shift_ena = (counter != 2'b00);

endmodule