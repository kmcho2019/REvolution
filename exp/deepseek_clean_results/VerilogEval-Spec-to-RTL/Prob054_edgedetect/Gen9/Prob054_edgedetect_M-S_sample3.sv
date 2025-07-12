module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    always @(posedge clk) begin
        pedge <= in & ~(in - pedge);  // in - pedge gives previous value
    end

endmodule