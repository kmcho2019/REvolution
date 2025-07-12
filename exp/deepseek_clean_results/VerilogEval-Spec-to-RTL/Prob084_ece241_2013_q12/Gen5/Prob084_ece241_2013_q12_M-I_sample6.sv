module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    wire gated_clk;
    assign gated_clk = clk & enable;  // Simple clock gating
    
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};  // Shift left, MSB first
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};

    ShiftRegister8bit sr (
        .clk(clk),
        .enable(1'b1),  // Enable now handled by clock gating
        .S(S),
        .Q(Q)
    );

    // Direct mux implementation without separate module
    assign Z = Q[sel];
endmodule