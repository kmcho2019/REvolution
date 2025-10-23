module TopModule(
    input [7:0] in,
    output parity
);

reg [7:0] temp;
reg parity_temp;

initial begin
    temp = 8'b0;
    parity_temp = 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity_temp = parity_temp ^ in[i];
    end
    parity = parity_temp;
end

always @(*) begin
    temp = in;
    parity_temp = 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity_temp = parity_temp ^ temp[i];
    end
    parity = parity_temp;
end

endmodule