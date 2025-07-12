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

// Shift register
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// 3-to-8 decoder
wire [7:0] dec_out;
assign dec_out = 8'b1 << ({A, B, C});

// 8-to-1 multiplexer
always @(*) begin
    Z = (dec_out[0] && Q[0]) || (dec_out[1] && Q[1]) || (dec_out[2] && Q[2]) || (dec_out[3] && Q[3]) || (dec_out[4] && Q[4]) || (dec_out[5] && Q[5]) || (dec_out[6] && Q[6]) || (dec_out[7] && Q[7]);
end

endmodule