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

// Distributed memory
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// Priority encoder
reg [2:0] sel;
always @(*) begin
    case ({A, B, C})
        3'b000: sel = 3'b000;
        3'b001: sel = 3'b001;
        3'b010: sel = 3'b010;
        3'b011: sel = 3'b011;
        3'b100: sel = 3'b100;
        3'b101: sel = 3'b101;
        3'b110: sel = 3'b110;
        3'b111: sel = 3'b111;
        default: sel = 3'bx;
    endcase
end

// Multiplexer
always @(*) begin
    case (sel)
        3'b000: Z = Q[0];
        3'b001: Z = Q[1];
        3'b010: Z = Q[2];
        3'b011: Z = Q[3];
        3'b100: Z = Q[4];
        3'b101: Z = Q[5];
        3'b110: Z = Q[6];
        3'b111: Z = Q[7];
        default: Z = 1'bx;
    endcase
end

endmodule