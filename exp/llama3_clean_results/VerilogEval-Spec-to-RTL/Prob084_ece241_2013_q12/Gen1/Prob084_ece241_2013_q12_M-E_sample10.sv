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

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

wire [1:0] group0 = {Q[1], Q[0]};
wire [1:0] group1 = {Q[3], Q[2]};
wire [1:0] group2 = {Q[5], Q[4]};
wire [1:0] group3 = {Q[7], Q[6]};

wire [1:0] group_out;
always @(*) begin
    case (C)
        1'b0: group_out = (B)? group1 : group0;
        1'b1: group_out = (B)? group3 : group2;
        default: group_out = 2'bx;
    endcase
end

always @(*) begin
    case (A)
        1'b0: Z = group_out[0];
        1'b1: Z = group_out[1];
        default: Z = 1'bx;
    endcase
end

endmodule