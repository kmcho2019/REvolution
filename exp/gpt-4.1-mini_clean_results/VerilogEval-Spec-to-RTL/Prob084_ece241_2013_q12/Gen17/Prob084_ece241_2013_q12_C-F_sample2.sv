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

    // Sequential shift register update with synchronous enable gating
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Output multiplexer using direct indexing by {A,B,C}
    assign Z = Q[{A, B, C}];

endmodule