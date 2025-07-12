module TopModule (
    input  wire clk,
    input  wire reset,         // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter = 3'd0;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd3;  // count down 3 cycles after reset cycle = total 4 cycles asserted
        end else if (counter != 0) begin
            counter <= counter - 1'b1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule