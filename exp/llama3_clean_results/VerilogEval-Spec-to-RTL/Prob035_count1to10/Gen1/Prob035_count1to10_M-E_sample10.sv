module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

localparam STATE_1 = 4'b0001;
localparam STATE_2 = 4'b0010;
localparam STATE_3 = 4'b0011;
localparam STATE_4 = 4'b0100;
localparam STATE_5 = 4'b0101;
localparam STATE_6 = 4'b0110;
localparam STATE_7 = 4'b0111;
localparam STATE_8 = 4'b1000;
localparam STATE_9 = 4'b1001;
localparam STATE_10 = 4'b1010;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_1; // Reset to state 1
    end else if (state == STATE_10) begin
        state <= STATE_1; // Wrap around from state 10 to state 1
    end else begin
        case (state)
            STATE_1: state <= STATE_2;
            STATE_2: state <= STATE_3;
            STATE_3: state <= STATE_4;
            STATE_4: state <= STATE_5;
            STATE_5: state <= STATE_6;
            STATE_6: state <= STATE_7;
            STATE_7: state <= STATE_8;
            STATE_8: state <= STATE_9;
            STATE_9: state <= STATE_10;
            default: state <= STATE_1; // Default to state 1 for any invalid state
        endcase
    end
end

assign q = state;

endmodule