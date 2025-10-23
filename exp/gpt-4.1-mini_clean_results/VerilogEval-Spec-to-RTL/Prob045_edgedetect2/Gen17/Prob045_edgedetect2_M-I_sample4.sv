module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    // anyedge is 1 if current and previous bits differ => edge occurred last cycle
    assign anyedge = in ^ prev_in;

endmodule