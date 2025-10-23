module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter;

    // Counter logic: load 4 on reset, decrement if > 0
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1'b1;
        end
    end

    // shift_ena is high while counter is non-zero
    assign shift_ena = (counter != 0);

endmodule