module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] counter;

    // Counter logic: load 4 on reset, decrement if nonzero
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    // shift_ena asserted when counter is nonzero
    assign shift_ena = (counter != 0);

endmodule