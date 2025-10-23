module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    case (state)
        4'd0: if (reset) state <= 4'd0; else state <= 4'd1;
        4'd1: if (reset) state <= 4'd0; else state <= 4'd2;
        4'd2: if (reset) state <= 4'd0; else state <= 4'd3;
        4'd3: if (reset) state <= 4'd0; else state <= 4'd4;
        4'd4: if (reset) state <= 4'd0; else state <= 4'd5;
        4'd5: if (reset) state <= 4'd0; else state <= 4'd6;
        4'd6: if (reset) state <= 4'd0; else state <= 4'd7;
        4'd7: if (reset) state <= 4'd0; else state <= 4'd8;
        4'd8: if (reset) state <= 4'd0; else state <= 4'd9;
        4'd9: if (reset) state <= 4'd0; else state <= 4'd0;
        default: state <= 4'd0;
    endcase
end

assign q = state;

endmodule