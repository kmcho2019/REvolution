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
    wire gated_clk;
    wire [2:0] sel = {A, B, C};

    // Clock gating cell
    assign gated_clk = clk & enable;

    // Shift register with clock gating
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};  // Efficient vector shift operation
    end

    // Optimized 8:1 mux
    assign Z = Q[sel];  // Direct-index mux implementation
endmodule