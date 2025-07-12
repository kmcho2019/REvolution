module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

    reg [2:0] counter;

    // Counter logic: On reset, load 4; else count down if > 0
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (counter != 3'd0) begin
            counter <= counter - 1;
        end
    end

    // shift_ena is high whenever counter > 0
    assign shift_ena = (counter != 3'd0);

endmodule