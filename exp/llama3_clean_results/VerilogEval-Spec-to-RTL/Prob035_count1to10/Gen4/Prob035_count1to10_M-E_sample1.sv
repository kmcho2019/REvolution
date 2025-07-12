module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] nextState;

always @(*) begin
    case (state)
        4'd1: nextState = 4'd2;
        4'd2: nextState = 4'd3;
        4'd3: nextState = 4'd4;
        4'd4: nextState = 4'd5;
        4'd5: nextState = 4'd6;
        4'd6: nextState = 4'd7;
        4'd7: nextState = 4'd8;
        4'd8: nextState = 4'd9;
        4'd9: nextState = 4'd10;
        4'd10: nextState = 4'd1;
        default: nextState = 4'd1;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd1;
    end else begin
        state <= nextState;
    end
end

assign q = state;

endmodule