module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Next state lookup table for decade count 0..9
wire [3:0] next_q;

reg [3:0] lut [0:9];
integer i;

initial begin
    lut[0] = 4'd1;
    lut[1] = 4'd2;
    lut[2] = 4'd3;
    lut[3] = 4'd4;
    lut[4] = 4'd5;
    lut[5] = 4'd6;
    lut[6] = 4'd7;
    lut[7] = 4'd8;
    lut[8] = 4'd9;
    lut[9] = 4'd0;
end

assign next_q = (q <= 4'd9) ? lut[q] : 4'd0;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena) begin
        q <= next_q;
    end
    // else hold q
end

endmodule