module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] nextState;

localparam STATE_1 = 4'd1;
localparam STATE_2 = 4'd2;
localparam STATE_3 = 4'd3;
localparam STATE_4 = 4'd4;
localparam STATE_5 = 4'd5;
localparam STATE_6 = 4'd6;
localparam STATE_7 = 4'd7;
localparam STATE_8 = 4'd8;
localparam STATE_9 = 4'd9;
localparam STATE_10 = 4'd10;

always @(*) begin
    case(state)
        STATE_1: nextState = STATE_2;
        STATE_2: nextState = STATE_3;
        STATE_3: nextState = STATE_4;
        STATE_4: nextState = STATE_5;
        STATE_5: nextState = STATE_6;
        STATE_6: nextState = STATE_7;
        STATE_7: nextState = STATE_8;
        STATE_8: nextState = STATE_9;
        STATE_9: nextState = STATE_10;
        STATE_10: nextState = STATE_1;
        default: nextState = STATE_1;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_1;
    end else begin
        state <= nextState;
    end
end

assign q = state;

endmodule