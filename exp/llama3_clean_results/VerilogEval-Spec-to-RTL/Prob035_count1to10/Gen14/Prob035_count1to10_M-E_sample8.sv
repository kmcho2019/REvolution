module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state; // 10 states for counts 1 to 10
reg [3:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd1; // Reset to count 1
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        4'd1: next_state = 4'd2;
        4'd2: next_state = 4'd3;
        4'd3: next_state = 4'd4;
        4'd4: next_state = 4'd5;
        4'd5: next_state = 4'd6;
        4'd6: next_state = 4'd7;
        4'd7: next_state = 4'd8;
        4'd8: next_state = 4'd9;
        4'd9: next_state = 4'd10;
        4'd10: next_state = 4'd1;
        default: next_state = 4'd1; // Handle any invalid states
    endcase
end

assign q = state;

endmodule