module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        case (q)
            4: q <= 5;
            5: q <= 6;
            6: q <= 0;
            0: q <= 1;
            default: q <= q + 1;
        endcase
    end
end

initial q = 4;

endmodule