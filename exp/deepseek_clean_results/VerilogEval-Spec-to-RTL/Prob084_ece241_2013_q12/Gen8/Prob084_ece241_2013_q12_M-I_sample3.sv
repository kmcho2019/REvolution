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
    wire gated_clk = enable ? clk : 0;  // Simple clock gating
    
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};  // Efficient vector shift operation
    end

    // Direct 8:1 mux implementation
    assign Z = Q[{A, B, C}];
endmodule