module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] state;

always @(posedge clk)
    if (reset) begin
        state <= 4'd0;
    end else begin
        case (state)
            4'd0: state <= 4'd1;
            4'd1: state <= 4'd2;
            4'd2: state <= 4'd3;
            4'd3: state <= 4'd4;
            4'd4: state <= 4'd5;
            4'd5: state <= 4'd6;
            4'd6: state <= 4'd7;
            4'd7: state <= 4'd8;
            4'd8: state <= 4'd9;
            4'd9: state <= 4'd10;
            4'd10: state <= 4'd11;
            4'd11: state <= 4'd12;
            4'd12: state <= 4'd13;
            4'd13: state <= 4'd14;
            4'd14: state <= 4'd15;
            4'd15: state <= 4'd0;
            default: state <= 4'd0;
        endcase
    end

assign q = state;

endmodule