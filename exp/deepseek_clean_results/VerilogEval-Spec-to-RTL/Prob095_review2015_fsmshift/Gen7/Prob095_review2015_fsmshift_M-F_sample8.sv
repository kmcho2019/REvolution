module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // Combinational output - high for first 4 cycles (0-3)
    assign shift_ena = (counter < 2'd3) || reset;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'd0;
        end else if (counter < 2'd3) begin
            counter <= counter + 1;
        end
    end

endmodule