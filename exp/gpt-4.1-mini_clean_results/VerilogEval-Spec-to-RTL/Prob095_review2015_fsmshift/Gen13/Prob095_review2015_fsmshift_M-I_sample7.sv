module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [1:0] counter; // 2-bit counter enough to count 0..3 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            // On reset, prepare to enable shift_ena starting next cycle
            counter <= 2'd3;   // 4 cycles counting down: 3,2,1,0
            shift_ena <= 1'b0; // shift_ena starts low during reset
        end else if (counter != 2'd0) begin
            counter <= counter - 1;
            shift_ena <= 1'b1; // enable shift_ena during countdown >0
        end else if (counter == 2'd0) begin
            // last cycle with shift_ena high
            shift_ena <= 1'b1;
            counter <= counter - 1; // counter underflows to 2'd3 but no reset, so...
            // To avoid wrap-around, let's saturate counter at 0 after last cycle:
            counter <= counter; // hold at zero to prevent wrap-around
        end else begin
            // After counting down to zero and one cycle of shift_ena,
            // deassert shift_ena indefinitely
            shift_ena <= 1'b0;
        end
    end

endmodule