module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1;
        counter <= 2'd0;
    end else if (counter < 4) begin
        counter <= counter + 1;
        if (counter == 4) begin
            shift_ena <= 1'b0;
        end
    end
end

endmodule