module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state_reg;
reg [3:0] next_state;

always @(*) begin
    case (state_reg)
        4'd0: next_state = slowena ? 4'd1 : 4'd0;
        4'd1: next_state = slowena ? 4'd2 : 4'd1;
        4'd2: next_state = slowena ? 4'd3 : 4'd2;
        4'd3: next_state = slowena ? 4'd4 : 4'd3;
        4'd4: next_state = slowena ? 4'd5 : 4'd4;
        4'd5: next_state = slowena ? 4'd6 : 4'd5;
        4'd6: next_state = slowena ? 4'd7 : 4'd6;
        4'd7: next_state = slowena ? 4'd8 : 4'd7;
        4'd8: next_state = slowena ? 4'd9 : 4'd8;
        4'd9: next_state = slowena ? 4'd0 : 4'd9;
        default: next_state = 4'd0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 4'd0;
    end else begin
        state_reg <= next_state;
    end
end

assign q = state_reg;

endmodule