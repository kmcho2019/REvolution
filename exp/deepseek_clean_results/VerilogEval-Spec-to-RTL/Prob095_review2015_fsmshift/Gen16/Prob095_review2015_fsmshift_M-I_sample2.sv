module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;

    assign shift_ena = (counter < 3'b100);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b000;
        end else if (counter < 3'b100) begin
            counter <= counter + 1;
        end
    end

endmodule