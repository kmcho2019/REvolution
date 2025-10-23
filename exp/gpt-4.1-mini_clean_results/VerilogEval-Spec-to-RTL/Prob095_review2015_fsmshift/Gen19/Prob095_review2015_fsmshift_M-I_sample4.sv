module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;       // Clear counter on reset
        end else if (counter == 0) begin
            counter <= 3'd4;       // Load 4 to start 4 cycles enable after reset
        end else begin
            counter <= counter - 1; // Count down while non-zero
        end
    end

    assign shift_ena = (counter != 0);

endmodule