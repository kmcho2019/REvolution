module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1, in_d2;

    always @(posedge clk) begin
        in_d1 <= in;                // First stage pipeline register captures current input
        in_d2 <= in_d1;             // Second stage pipeline register delays by one more cycle
        pedge <= (~in_d2) & in_d1;  // Detect 0-to-1 transitions between in_d2 and in_d1 (delayed inputs)
    end

endmodule