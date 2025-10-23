module TopModule (
    input  wire clk,
    input  wire reset,           // synchronous active high
    input  wire pattern_detected,
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (pattern_detected) begin
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule