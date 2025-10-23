module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;

    // Combinational output - high for first 4 cycles (0-3)
    assign shift_ena = (counter < 3'd4);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
        end else if (counter < 3'd4) begin
            counter <= counter + 1;
        end
    end

endmodule