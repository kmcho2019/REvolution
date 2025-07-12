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

    // 8-bit shift register using always_ff for sequential logic
    always_ff @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // Multiplexer to select the output
    assign Z = Q[{A, B, C}];

endmodule