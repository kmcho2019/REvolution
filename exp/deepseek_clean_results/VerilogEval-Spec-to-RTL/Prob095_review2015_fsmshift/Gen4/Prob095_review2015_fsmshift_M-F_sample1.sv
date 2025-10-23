module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] counter;  // 3-bit counter for counting 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b100;  // Load 4 for 4 cycles (4,3,2,1)
            shift_ena <= 1'b1;  // Assert immediately on reset
        end else begin
            if (counter != 3'b000) begin
                counter <= counter - 1;
                shift_ena <= 1'b1;  // Keep asserted while counting
            end else begin
                shift_ena <= 1'b0;  // Deassert when done
            end
        end
    end

endmodule