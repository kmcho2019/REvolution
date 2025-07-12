module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // 2-bit counter to count up to 3 (4 clock cycles)

always @ (posedge clk) begin
    if (reset) begin
        counter <= 0;
        shift_ena <= 1'b1;
    end else if (counter < 4) begin
        counter <= counter + 1;
        shift_ena <= (counter < 4) ? 1'b1 : 1'b0;
    end else begin
        shift_ena <= 1'b0;
    end
end

endmodule