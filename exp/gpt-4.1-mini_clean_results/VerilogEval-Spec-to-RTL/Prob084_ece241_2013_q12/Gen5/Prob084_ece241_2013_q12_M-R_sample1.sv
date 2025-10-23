module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // 8-to-1 multiplexer using vector indexing with concatenated ABC
    assign Z = Q[{A, B, C}];

endmodule