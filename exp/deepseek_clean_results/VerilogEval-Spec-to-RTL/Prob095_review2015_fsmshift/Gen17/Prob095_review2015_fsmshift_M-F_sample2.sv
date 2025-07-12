module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;

    assign shift_ena = (counter < 3'd4) && !reset;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
        end else if (counter < 3'd4) begin
            counter <= counter + 1;
        end
    end

endmodule