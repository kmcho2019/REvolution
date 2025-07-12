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

    // 8-bit shift register
    always @(posedge clk) begin
        if (enable) begin
            Q[7:1] <= Q[6:0];
            Q[0] <= S;
        end
    end

    // Simplified multiplexer to select the output
    assign Z = Q[{A, B, C}];

endmodule