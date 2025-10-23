module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state;

localparam [3:0] STATE_0 = 4'b0000;
localparam [3:0] STATE_1 = 4'b0001;
localparam [3:0] STATE_2 = 4'b0010;
localparam [3:0] STATE_3 = 4'b0011;
localparam [3:0] STATE_4 = 4'b0100;
localparam [3:0] STATE_5 = 4'b0101;
localparam [3:0] STATE_6 = 4'b0110;
localparam [3:0] STATE_7 = 4'b0111;
localparam [3:0] STATE_8 = 4'b1000;
localparam [3:0] STATE_9 = 4'b1001;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_0;
    end else if (slowena) begin
        case (state)
            STATE_0: state <= STATE_1;
            STATE_1: state <= STATE_2;
            STATE_2: state <= STATE_3;
            STATE_3: state <= STATE_4;
            STATE_4: state <= STATE_5;
            STATE_5: state <= STATE_6;
            STATE_6: state <= STATE_7;
            STATE_7: state <= STATE_8;
            STATE_8: state <= STATE_9;
            STATE_9: state <= STATE_0;
            default: state <= STATE_0;
        endcase
    end
end

assign q = state;

endmodule