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

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S}; // Shift left and shift in S at LSB (Q[0] is MSB)
        end
    end

    // Continuous assignment for output multiplexer using vector indexing
    assign Z = Q[{A, B, C}];

endmodule