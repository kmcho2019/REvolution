module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1, in_d2;

    always @(posedge clk) begin
        in_d2 <= in_d1;
        in_d1 <= in;
        pedge <= (~in_d2) & in_d1;  // Rising edge detected between in_d2 (prev-prev) and in_d1 (prev)
    end

endmodule