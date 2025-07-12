module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1;
        counter <= 0;
    end else if (counter < 4) begin
        shift_ena <= 1;
        counter <= counter + 1;
    end else begin
        shift_ena <= 0;
    end
end

endmodule