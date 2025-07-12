module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;
    reg reset_d;  // delayed reset for edge detection

    always @(posedge clk) begin
        reset_d <= reset;
        if (reset) begin
            // Hold counter at 0 during reset
            counter <= 3'd0;
        end else if (reset_d && !reset) begin
            // On falling edge of reset (release), start counting 4 cycles
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule