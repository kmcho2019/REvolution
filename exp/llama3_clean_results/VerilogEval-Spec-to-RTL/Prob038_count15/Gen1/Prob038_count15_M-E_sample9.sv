module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [15:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 16'd1; // one-hot encoded state for count value 0
    end else begin
        state <= {state[14:0], state[15]}; // rotate the one-hot encoded state
    end
end

always @(*) begin
    case (state)
        16'd1: q = 4'd0;
        16'd2: q = 4'd1;
        16'd4: q = 4'd2;
        16'd8: q = 4'd3;
        16'd16: q = 4'd4;
        16'd32: q = 4'd5;
        16'd64: q = 4'd6;
        16'd128: q = 4'd7;
        16'd256: q = 4'd8;
        16'd512: q = 4'd9;
        16'd1024: q = 4'd10;
        16'd2048: q = 4'd11;
        16'd4096: q = 4'd12;
        16'd8192: q = 4'd13;
        16'd16384: q = 4'd14;
        16'd32768: q = 4'd15;
        default: q = 4'd0;
    endcase
end

endmodule