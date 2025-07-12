module DFF(
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input enable,
    input S,
    output [WIDTH-1:0] Q
);
    wire [WIDTH-1:0] d_inputs;
    
    // First flip-flop gets the shift input
    assign d_inputs[0] = enable ? S : Q[0];
    DFF ff0(.clk(clk), .d(d_inputs[0]), .q(Q[0]));
    
    // Remaining flip-flops form the shift chain
    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : shift_chain
            assign d_inputs[i] = enable ? Q[i-1] : Q[i];
            DFF ff(.clk(clk), .d(d_inputs[i]), .q(Q[i]));
        end
    endgenerate
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

    // Mux implemented with case statement
    reg Z_reg;
    always @(*) begin
        case (sel)
            3'b000: Z_reg = Q[0];
            3'b001: Z_reg = Q[1];
            3'b010: Z_reg = Q[2];
            3'b011: Z_reg = Q[3];
            3'b100: Z_reg = Q[4];
            3'b101: Z_reg = Q[5];
            3'b110: Z_reg = Q[6];
            3'b111: Z_reg = Q[7];
            default: Z_reg = 1'b0;
        endcase
    end
    assign Z = Z_reg;
endmodule