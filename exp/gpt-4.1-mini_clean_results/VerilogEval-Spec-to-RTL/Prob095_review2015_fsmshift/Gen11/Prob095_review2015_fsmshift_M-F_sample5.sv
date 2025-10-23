module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, load counter to 4 and assert shift_ena immediately
            counter   <= 3'd4;
            shift_ena <= 1'b1;
        end else if (counter != 3'd0) begin
            // Decrement counter and keep shift_ena asserted
            counter   <= counter - 1;
            shift_ena <= 1'b1;
        end else begin
            // After 4 cycles, deassert shift_ena forever until next reset
            shift_ena <= 1'b0;
        end
    end

endmodule