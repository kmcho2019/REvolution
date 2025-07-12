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
    input S,
    output reg [WIDTH-1:0] Q
);

integer i;
always @(posedge clk) begin
    if (enable) begin
        Q[0] <= S;
        for (i = 1; i < WIDTH; i++) begin
            Q[i] <= Q[i-1];
        end
    end
end

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
   .S(S),
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
    endcase
end

endmodule