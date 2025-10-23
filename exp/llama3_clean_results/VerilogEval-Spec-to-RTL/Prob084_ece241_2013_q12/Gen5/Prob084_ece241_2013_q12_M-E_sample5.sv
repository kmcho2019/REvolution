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
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

wire [2:0] addr = {A, B, C};
reg [7:0] shifted_Q;

always @(*) begin
    case (addr)
        3'b000: shifted_Q = {Q[7], Q[7:1]};
        3'b001: shifted_Q = {Q[6], Q[7:2]};
        3'b010: shifted_Q = {Q[5], Q[7:3]};
        3'b011: shifted_Q = {Q[4], Q[7:4]};
        3'b100: shifted_Q = {Q[3], Q[7:5]};
        3'b101: shifted_Q = {Q[2], Q[7:6]};
        3'b110: shifted_Q = {Q[1], Q[7:7]};
        3'b111: shifted_Q = {Q[0], Q[7:8]};
        default: shifted_Q = 8'b0;
    endcase
end

assign Z = shifted_Q[0];

endmodule