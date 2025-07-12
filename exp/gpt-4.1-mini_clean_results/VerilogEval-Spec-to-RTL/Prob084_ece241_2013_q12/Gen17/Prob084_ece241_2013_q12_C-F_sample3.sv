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

    // 8-bit shift register with synchronous enable: shift right, insert S at MSB
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Combinational 8-to-1 multiplexer for output Z using vector indexing
    assign Z = Q[{A, B, C}];

endmodule