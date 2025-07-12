module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge = 0
);

    always @(posedge clk) begin
        anyedge <= in ^ anyedge ^ in;  // Equivalent to in ^ prev_in
    end

endmodule