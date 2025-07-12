module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q <= {S, Q[7:1]};
    end
end

reg [2:0] addr;
assign addr = {A, B, C};

reg [7:0] data;
assign data = Q;

reg [7:0] out;
always @(*) begin
    case (addr)
        3'b000: out = {7'b0000000, data[0]};
        3'b001: out = {7'b0000000, data[1]};
        3'b010: out = {7'b0000000, data[2]};
        3'b011: out = {7'b0000000, data[3]};
        3'b100: out = {7'b0000000, data[4]};
        3'b101: out = {7'b0000000, data[5]};
        3'b110: out = {7'b0000000, data[6]};
        3'b111: out = {7'b0000000, data[7]};
        default: out = 8'b00000000;
    endcase
end

assign Z = out[0];

endmodule