module DFF(
    input clk,
    input enable,
    input D,
    output reg Q
);

always @(posedge clk) begin
    if (enable) begin
        Q <= D;
    end
end

endmodule

module ShiftRegister(
    parameter WIDTH = 8,
    input clk,
    input enable,
    input D,
    output [WIDTH-1:0] Q
);

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin
        if (i == 0) begin
            DFF dff(
               .clk(clk),
               .enable(enable),
               .D(D),
               .Q(Q[i])
            );
        end else begin
            DFF dff(
               .clk(clk),
               .enable(enable),
               .D(Q[i-1]),
               .Q(Q[i])
            );
        end
    end
endgenerate

endmodule

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

ShiftRegister #(.WIDTH(8)) shift_register(
   .clk(clk),
   .enable(enable),
   .D(S),
   .Q(Q)
);

always @(posedge clk) begin
    case ({A, B, C})
        3'b000: Z <= Q[0];
        3'b001: Z <= Q[1];
        3'b010: Z <= Q[2];
        3'b011: Z <= Q[3];
        3'b100: Z <= Q[4];
        3'b101: Z <= Q[5];
        3'b110: Z <= Q[6];
        3'b111: Z <= Q[7];
        default: Z <= 1'bx;
    endcase
end

endmodule