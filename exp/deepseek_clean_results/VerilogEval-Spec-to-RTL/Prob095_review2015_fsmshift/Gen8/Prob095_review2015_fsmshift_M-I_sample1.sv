module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            shift_ena <= 1'b1;
        end else if (shift_ena) begin
            counter <= counter + 1;
            shift_ena <= (counter != 2'b11);
        end
    end

endmodule