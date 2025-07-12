module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] ena_counter; // 3-bit counter sufficient for count 4

    always @(posedge clk) begin
        if (reset) begin
            ena_counter <= 3'd4;    // Load 4 on reset
        end else if (ena_counter != 0) begin
            ena_counter <= ena_counter - 1'b1; // Count down to 0
        end
    end

    always @(posedge clk) begin
        // shift_ena is asserted as long as counter is non-zero
        shift_ena <= (ena_counter != 0);
    end

endmodule