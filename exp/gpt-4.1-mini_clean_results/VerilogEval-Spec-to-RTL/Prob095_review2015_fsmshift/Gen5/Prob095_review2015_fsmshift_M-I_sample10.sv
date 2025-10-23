module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;

    // Counter update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd3;    // Initialize counter to 3 on reset
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    // shift_ena asserted while counter is >= 1 (exactly 4 cycles after reset)
    assign shift_ena = (counter != 0);

endmodule