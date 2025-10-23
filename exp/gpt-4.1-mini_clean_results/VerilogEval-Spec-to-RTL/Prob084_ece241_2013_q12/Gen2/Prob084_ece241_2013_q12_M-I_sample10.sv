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

    // Shift register with vector assignment for efficient synthesis
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // Multiplexer output using direct indexing
    assign Z = Q[{A, B, C}];

endmodule