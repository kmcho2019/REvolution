module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a) begin
        q <= 4; // reset q to 4 when a is high
    end else begin
        if (q == 7) begin
            q <= 0; // wrap around to 0 when q reaches 7
        end else if (q == 0) begin
            q <= 1; // set q to 1 when q is 0
        end else begin
            q <= q + 1; // increment q otherwise
        end
    end
end

endmodule