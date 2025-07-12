module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;

    // Counter logic - counts down from 4 to 0
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b100; // Initialize to 4 (for 4 cycles)
        end else if (counter != 3'b000) begin
            counter <= counter - 1'b1;
        end
    end

    // Output is high when counter is not zero
    assign shift_ena = (counter != 3'b000);

endmodule