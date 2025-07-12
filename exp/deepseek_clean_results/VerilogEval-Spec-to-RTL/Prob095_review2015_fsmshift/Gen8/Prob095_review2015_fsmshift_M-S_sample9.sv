module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;  // Start counting from 0
        end else if (counter != 2'b11) begin
            counter <= counter + 1'b1;  // Increment until 3
        end
    end

    assign shift_ena = (reset || (counter != 2'b11));

endmodule