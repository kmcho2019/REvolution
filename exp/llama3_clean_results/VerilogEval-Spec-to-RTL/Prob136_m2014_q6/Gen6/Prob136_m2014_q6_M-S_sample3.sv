module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state;

always @(posedge clk) begin
    if (reset) state <= 0;
    else
    case (state)
        0: state <= w ? 0 : 1;
        1: state <= w ? 3 : 2;
        2: state <= w ? 3 : 4;
        3: state <= w ? 0 : 5;
        4: state <= w ? 3 : 4;
        5: state <= w ? 3 : 2;
        default: state <= 0;
    endcase
end

always @(*) begin
    case (state)
        4, 5: z = 1;
        default: z = 0;
    endcase
end

endmodule