module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (~a) begin
        if (q == 3'b111) // wrap around to 0 when q reaches 7
            q <= 3'b000;
        else
            q <= q + 1'b1;
    end
    else begin // when a is 1, set q to 4
        q <= 3'b100;
    end
end

endmodule