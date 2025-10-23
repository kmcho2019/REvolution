module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end else if (counter < 2'b11) begin
            counter <= counter + 1;
        end
    end

    // Output is active for first 4 cycles (0-3) after reset
    assign shift_ena = (counter < 2'b11);

endmodule