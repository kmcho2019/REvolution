module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input enable,
    input S,
    output reg [WIDTH-1:0] Q
);
    wire gated_clk;
    
    // Latch-based clock gating
    reg enable_latch;
    always @(*) begin
        if (~clk) enable_latch = enable;
    end
    assign gated_clk = clk & enable_latch;

    always @(posedge gated_clk) begin
        Q <= {Q[WIDTH-2:0], S};  // Efficient parameterized shift
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
    parameter WIDTH = 8;
    wire [WIDTH-1:0] Q;
    wire [2:0] sel = {A, B, C};

    ShiftRegister #(
        .WIDTH(WIDTH)
    ) sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    assign Z = Q[sel];  // Optimal direct-index mux
endmodule