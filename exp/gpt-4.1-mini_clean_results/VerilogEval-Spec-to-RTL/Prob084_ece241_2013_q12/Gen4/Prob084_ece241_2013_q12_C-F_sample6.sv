module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;

    // 8-bit shift register with synchronous active-high enable
    // Shift left: MSB shifted in first from S, LSB shifted out
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // 8-to-1 multiplexer output Z selected by ABC
    assign Z = Q[{A, B, C}];

endmodule