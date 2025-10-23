module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter; // 3-bit counter to count 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4; // initialize to 4 cycles
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    // Assert shift_ena while counter is non-zero (exactly 4 cycles after reset)
    assign shift_ena = (counter != 0);

endmodule