module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'd1; // initialize the LFSR
    end else begin
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[1]}; // LFSR with polynomial x^4 + x + 1
    end
end

always @(*) begin
    case (lfsr)
        4'd1: q = 4'd0;
        4'd11: q = 4'd1;
        4'd10: q = 4'd2;
        4'd14: q = 4'd3;
        4'd7: q = 4'd4;
        4'd12: q = 4'd5;
        4'd6: q = 4'd6;
        4'd13: q = 4'd7;
        4'd4: q = 4'd8;
        4'd3: q = 4'd9;
        4'd5: q = 4'd10;
        4'd15: q = 4'd11;
        4'd8: q = 4'd12;
        4'd9: q = 4'd13;
        4'd2: q = 4'd14;
        4'd0: q = 4'd15;
        default: q = 4'd0;
    endcase
end

endmodule