module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1;
        counter <= 2'b00;
    end else if (counter == 4'b1000) begin
        shift_ena <= 0;
    end else if (shift_ena) begin
        counter <= counter + 1;
        if (counter == 4'b1000) begin
            shift_ena <= 0;
        end
    end
end

endmodule