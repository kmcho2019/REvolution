module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);
    reg [7:0] Q;
    wire gated_clk = clk & enable;  // Clock gating
    
    // Shift register with clock gating
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end

    // Output register for better timing
    always @(posedge clk) begin
        Z <= Q[{A, B, C}];  // Direct indexing mux
    end
endmodule