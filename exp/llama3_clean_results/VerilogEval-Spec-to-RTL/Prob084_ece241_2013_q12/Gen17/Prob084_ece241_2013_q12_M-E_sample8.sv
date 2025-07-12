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

// Define the shift register's behavior
always @(posedge clk) begin
    if (enable) begin
        for (int i = 7; i > 0; i--) begin
            Q[i] <= Q[i-1];
        end
        Q[0] <= S;
    end
end

// Use a LUT to implement the multiplexer
reg [7:0] lut[8];
always @(*) begin
    lut[0] = Q[0];
    lut[1] = Q[1];
    lut[2] = Q[2];
    lut[3] = Q[3];
    lut[4] = Q[4];
    lut[5] = Q[5];
    lut[6] = Q[6];
    lut[7] = Q[7];
end

assign Z = lut[{A, B, C}];

endmodule