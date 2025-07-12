module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else if (counter < 4) begin
        shift_ena <= 1'b1;
        counter <= counter + 1;
    end else begin
        shift_ena <= 1'b0;
    end
end

endmodule