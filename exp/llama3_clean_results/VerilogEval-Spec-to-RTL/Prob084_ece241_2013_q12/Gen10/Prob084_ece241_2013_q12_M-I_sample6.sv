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
wire clk_gated;

// Clock gate
assign clk_gated = enable ? clk : 1'b0;

// Shift register
always @(posedge clk_gated) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// 8-to-1 multiplexer using binary tree of multiplexers
always @(*) begin
    wire [7:0] temp;
    assign temp[0] = Q[0];
    assign temp[1] = Q[1];
    assign temp[2] = Q[2];
    assign temp[3] = Q[3];
    assign temp[4] = Q[4];
    assign temp[5] = Q[5];
    assign temp[6] = Q[6];
    assign temp[7] = Q[7];

    wire [3:0] sel = {A, B, C};
    reg [7:0] out;

    always @(*) begin
        case (sel[1:0])
            2'b00: out = (sel[2] == 0) ? temp[0] : temp[4];
            2'b01: out = (sel[2] == 0) ? temp[1] : temp[5];
            2'b10: out = (sel[2] == 0) ? temp[2] : temp[6];
            2'b11: out = (sel[2] == 0) ? temp[3] : temp[7];
        endcase
    end

    assign Z = out;
end

endmodule