module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input enable,
    input S,
    output reg [WIDTH-1:0] Q
);
    (* srl_style = "register" *)  // Hint for synthesis tool
    reg gated_clk;
    
    always @(*) begin
        gated_clk = clk & enable;  // Simple clock gating
    end

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
    output reg Z
);
    parameter WIDTH = 8;
    wire [WIDTH-1:0] Q;
    reg [2:0] sel_reg;  // Pipelined selector
    
    // Pipeline selector to reduce glitching
    always @(posedge clk) begin
        sel_reg <= {A, B, C};
    end

    ShiftRegister #(
        .WIDTH(WIDTH)
    ) sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    always @(*) begin
        Z = Q[sel_reg];  // Optimal direct-index mux
    end
endmodule