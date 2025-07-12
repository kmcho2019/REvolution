module TopModule #(
    parameter COUNT_START = 1,
    parameter COUNT_END = 10
)(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    case (count)
        COUNT_START: count <= COUNT_START + 1;
        COUNT_START + 1: count <= COUNT_START + 2;
        COUNT_START + 2: count <= COUNT_START + 3;
        COUNT_START + 3: count <= COUNT_START + 4;
        COUNT_START + 4: count <= COUNT_START + 5;
        COUNT_START + 5: count <= COUNT_START + 6;
        COUNT_START + 6: count <= COUNT_START + 7;
        COUNT_START + 7: count <= COUNT_START + 8;
        COUNT_START + 8: count <= COUNT_START + 9;
        COUNT_START + 9: count <= COUNT_START;
        default: count <= COUNT_START;
    endcase
    
    if (reset) begin
        count <= COUNT_START;
    end
end

assign q = count;

initial begin
    count = COUNT_START;
end

endmodule