module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    assign shift_ena = (counter < 2'b11);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end else if (shift_ena) begin
            counter <= counter + 1;
        end
    end

endmodule