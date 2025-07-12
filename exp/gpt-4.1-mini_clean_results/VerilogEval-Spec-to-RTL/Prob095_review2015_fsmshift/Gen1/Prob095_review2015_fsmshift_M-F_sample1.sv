module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] ena_count; // 3-bit counter to count 4 cycles (0 to 4)

    always @(posedge clk) begin
        if (reset) begin
            ena_count <= 3'd4;    // Start with 4 cycles enabled on reset
        end else if (ena_count != 0) begin
            ena_count <= ena_count - 1;
        end

        // shift_ena asserted while ena_count > 0
        shift_ena <= (ena_count != 0);
    end

endmodule