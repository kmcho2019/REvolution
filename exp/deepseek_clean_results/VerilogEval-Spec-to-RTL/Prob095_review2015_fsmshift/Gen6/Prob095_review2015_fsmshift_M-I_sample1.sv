module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;  // 3-bit counter to count 0-4

    // shift_ena is high for first 4 cycles (counter 0-3)
    assign shift_ena = (counter < 3'd4);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
        end else if (counter < 3'd4) begin
            counter <= counter + 1;
        end
    end

endmodule