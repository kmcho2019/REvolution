module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [1:0] counter; // 2 bits count from 3 down to 0 (4 cycles total)

    always @(posedge clk) begin
        if (reset) begin
            counter   <= 2'd3;   // load counter to 3 on reset
            shift_ena <= 1'b1;   // assert shift_ena immediately
        end else if (counter != 2'd0) begin
            counter   <= counter - 1;
            shift_ena <= 1'b1;   // keep shift_ena asserted while counter > 0
        end else begin
            shift_ena <= 1'b0;   // deassert after 4 cycles
            counter   <= 2'd0;   // hold counter at zero
        end
    end

endmodule