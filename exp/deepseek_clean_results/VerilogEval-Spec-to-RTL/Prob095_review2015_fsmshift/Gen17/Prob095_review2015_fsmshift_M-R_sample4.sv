module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;  // 2 bits sufficient for 0-3 count

    // shift_ena active when counter is counting (0-3)
    assign shift_ena = (counter < 2'b11) | reset;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end else if (counter < 2'b11) begin
            counter <= counter + 1;
        end
    end

endmodule