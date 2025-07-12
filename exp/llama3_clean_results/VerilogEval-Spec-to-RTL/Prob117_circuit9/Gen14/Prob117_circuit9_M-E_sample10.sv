module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;

initial state = 4;

always @(posedge clk) begin
    case (state)
        0: if (!a) state <= 1; else state <= 4;
        1: if (!a) state <= 2; else state <= 4;
        2: if (!a) state <= 3; else state <= 4;
        3: if (!a) state <= 4; else state <= 4;
        4: if (!a) state <= 5; else state <= 4;
        5: if (!a) state <= 0; else state <= 4;
        6: if (!a) state <= 0; else state <= 4;
        default: state <= 4;
    endcase
end

always @(*) begin
    q = state;
end

endmodule