module TopModule (
    input clk,
    input [2:0] vec,
    output reg [2:0] outv,
    output reg o2,
    output reg o1,
    output reg o0
);

    always @(posedge clk) begin
        outv <= vec;        // Register the input vector
        o2 <= vec[2];       // Register each bit separately
        o1 <= vec[1];
        o0 <= vec[0];
    end

endmodule