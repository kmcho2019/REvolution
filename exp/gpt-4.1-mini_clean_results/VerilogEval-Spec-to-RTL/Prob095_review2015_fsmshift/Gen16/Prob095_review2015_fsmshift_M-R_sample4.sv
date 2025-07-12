module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;  // load 4 cycles when reset is asserted
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
        // else hold counter at 0
    end

    assign shift_ena = (counter != 0);

endmodule