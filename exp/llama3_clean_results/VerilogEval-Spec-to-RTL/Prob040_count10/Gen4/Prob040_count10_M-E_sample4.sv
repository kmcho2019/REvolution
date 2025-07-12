module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
    end else if (state == 4'd9) begin
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
            4'd9: state <= 4'd0;
            default: state <= 4'd0;
        endcase
    end
end

assign q = state;

endmodule