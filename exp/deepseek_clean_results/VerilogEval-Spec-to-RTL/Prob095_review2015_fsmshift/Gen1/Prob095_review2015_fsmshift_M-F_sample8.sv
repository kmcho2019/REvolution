module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // State transition and counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end else if (counter != 2'b11) begin
            counter <= counter + 1;
        end
    end

    // Output logic - enable for first 4 cycles (0-3)
    assign shift_ena = (reset || (counter != 2'b11));

endmodule