module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] previous;
    reg [7:0] current;

    always @(posedge clk) begin
        previous <= current;
        current <= in;
    end

    assign pedge = ~previous & current;

endmodule