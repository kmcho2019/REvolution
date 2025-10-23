module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'd3;
        end else if (counter != 0) begin
            counter <= counter - 1'b1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule