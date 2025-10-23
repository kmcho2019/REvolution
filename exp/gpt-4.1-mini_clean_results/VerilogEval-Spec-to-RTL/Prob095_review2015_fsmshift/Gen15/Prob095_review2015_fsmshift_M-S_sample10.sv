module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active-high reset
    output wire shift_ena
);

    reg [1:0] counter;
    reg reset_d;

    always @(posedge clk) begin
        reset_d <= reset;
        if (reset) begin
            counter <= 2'd0;           // hold counter at 0 during reset
        end else if (reset_d) begin
            // reset just released this cycle (reset_d was 1, now reset is 0)
            counter <= 2'd3;           // load 4 cycles counting from 3 down to 0
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule