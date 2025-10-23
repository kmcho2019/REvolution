module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] lfsr; // 5-bit LFSR

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        lfsr <= 5'b00000;
    end else begin
        lfsr <= {lfsr[3:0], IN};
    end
end

assign MATCH = (lfsr == 5'b10011);

endmodule