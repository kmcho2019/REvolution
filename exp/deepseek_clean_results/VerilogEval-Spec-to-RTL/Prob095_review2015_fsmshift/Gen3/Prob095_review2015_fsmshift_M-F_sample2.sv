module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;  // 3-bit counter for counting 4 cycles

    // shift_ena is high when counter is not zero
    assign shift_ena = (counter != 3'b000);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b100;  // Load 4 for 4 cycles (4,3,2,1)
        end else if (counter != 3'b000) begin
            counter <= counter - 1;
        end
        // When counter reaches 0, it stays 0 until next reset
    end

endmodule