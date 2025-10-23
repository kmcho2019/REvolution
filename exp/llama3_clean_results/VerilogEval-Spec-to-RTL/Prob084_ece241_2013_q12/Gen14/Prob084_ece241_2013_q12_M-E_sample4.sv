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

// 3-to-8 decoder to generate selection signals
wire [7:0] sel;
always @(*) begin
    sel = 8'b00000000;
    case ({A, B, C})
        3'b000: sel[0] = 1'b1;
        3'b001: sel[1] = 1'b1;
        3'b010: sel[2] = 1'b1;
        3'b011: sel[3] = 1'b1;
        3'b100: sel[4] = 1'b1;
        3'b101: sel[5] = 1'b1;
        3'b110: sel[6] = 1'b1;
        3'b111: sel[7] = 1'b1;
    endcase
end

// Shift register with 8 D-type flip-flops
always @(posedge clk) begin
    if (enable) begin
        Q[0] <= S;
        Q[1] <= Q[0];
        Q[2] <= Q[1];
        Q[3] <= Q[2];
        Q[4] <= Q[3];
        Q[5] <= Q[4];
        Q[6] <= Q[5];
        Q[7] <= Q[6];
    end
end

// Priority encoder to generate output Z
always @(*) begin
    case (1'b1)
        sel[0]: Z = Q[0];
        sel[1]: Z = Q[1];
        sel[2]: Z = Q[2];
        sel[3]: Z = Q[3];
        sel[4]: Z = Q[4];
        sel[5]: Z = Q[5];
        sel[6]: Z = Q[6];
        sel[7]: Z = Q[7];
    endcase
end

endmodule