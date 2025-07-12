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
        state <= (state == STATE_9)? STATE_0 : state + 1'b1;
    end
end

assign q = state;

endmodule