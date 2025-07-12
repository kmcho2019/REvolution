module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit shift register
    reg [7:0] Q;

    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB first
        end
    end

    // Optimal 3-to-8 multiplexer using direct indexing with explicit selector
    wire [2:0] sel = {A, B, C};
    assign Z = Q[sel];

endmodule