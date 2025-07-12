module TopModule (
    input            clk,
    input      [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1, in_d2;

    always @(posedge clk) begin
        in_d1 <= in;
        in_d2 <= in_d1;
        pedge <= (~in_d2) & in_d1;
    end

endmodule