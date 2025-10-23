module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 1;
    end else begin
        count <= next_count;
    end
end

always @(*) begin
    case (count)
        1: next_count = 2;
        2: next_count = 3;
        3: next_count = 4;
        4: next_count = 5;
        5: next_count = 6;
        6: next_count = 7;
        7: next_count = 8;
        8: next_count = 9;
        9: next_count = 10;
        10: next_count = 1;
        default: next_count = 1;
    endcase
end

assign q = count;

endmodule