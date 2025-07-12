module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] Q;

    // 8-bit shift register with clock enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Output assignment using the concatenation of A, B, and C as an index
    always @(*) begin
        Z = Q[{A, B, C}];
    end

endmodule