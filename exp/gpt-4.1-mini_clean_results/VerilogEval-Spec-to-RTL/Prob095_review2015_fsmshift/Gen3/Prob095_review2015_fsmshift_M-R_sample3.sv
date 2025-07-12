module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] count;

    // Counter increments each clock cycle after reset; stops at 4
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
        end else if (count < 3'd4) begin
            count <= count + 1'b1;
        end
    end

    // shift_ena asserted while count is less than 4 (4 cycles)
    assign shift_ena = (count < 3'd4);

endmodule