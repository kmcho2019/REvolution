module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;  // 2 bits sufficient for 0-3 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end else if (counter != 2'b11) begin
            counter <= counter + 1'b1;
        end
    end

    assign shift_ena = (reset || (counter != 2'b11));

endmodule