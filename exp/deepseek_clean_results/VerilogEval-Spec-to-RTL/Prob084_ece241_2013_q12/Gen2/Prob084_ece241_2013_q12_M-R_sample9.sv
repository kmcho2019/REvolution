module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit shift register implemented with vector operations
    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left and insert new bit at LSB
        end
    end

    // 8:1 multiplexer using direct array indexing
    assign Z = Q[{A, B, C}];

endmodule