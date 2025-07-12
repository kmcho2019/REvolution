module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;

always @ (posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1;
        counter <= 2'd3; // 4 clock cycles - 1
    end else if (counter != 0) begin
        shift_ena <= 1'b1;
        counter <= counter - 1;
    end else begin
        shift_ena <= 1'b0;
    end
end

endmodule