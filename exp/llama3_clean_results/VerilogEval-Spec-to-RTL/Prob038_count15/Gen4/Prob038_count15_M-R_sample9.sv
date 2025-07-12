module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] state, next_state;

always @(*) begin
    case (state)
        4'd0: next_state = (reset) ? 4'd0 : 4'd1;
        4'd1: next_state = (reset) ? 4'd0 : 4'd2;
        4'd2: next_state = (reset) ? 4'd0 : 4'd3;
        4'd3: next_state = (reset) ? 4'd0 : 4'd4;
        4'd4: next_state = (reset) ? 4'd0 : 4'd5;
        4'd5: next_state = (reset) ? 4'd0 : 4'd6;
        4'd6: next_state = (reset) ? 4'd0 : 4'd7;
        4'd7: next_state = (reset) ? 4'd0 : 4'd8;
        4'd8: next_state = (reset) ? 4'd0 : 4'd9;
        4'd9: next_state = (reset) ? 4'd0 : 4'd10;
        4'd10: next_state = (reset) ? 4'd0 : 4'd11;
        4'd11: next_state = (reset) ? 4'd0 : 4'd12;
        4'd12: next_state = (reset) ? 4'd0 : 4'd13;
        4'd13: next_state = (reset) ? 4'd0 : 4'd14;
        4'd14: next_state = (reset) ? 4'd0 : 4'd15;
        4'd15: next_state = (reset) ? 4'd0 : 4'd0;
        default: next_state = 4'd0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
    end else begin
        state <= next_state;
    end
    q <= state;
end

endmodule