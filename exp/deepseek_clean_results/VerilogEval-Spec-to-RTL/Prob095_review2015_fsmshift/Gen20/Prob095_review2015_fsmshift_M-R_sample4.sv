module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;  // 3-bit counter (counts 0-7)

    assign shift_ena = (counter < 3'd4);  // High for 0-3 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1;  // Will naturally roll over after 7
        end
    end

endmodule