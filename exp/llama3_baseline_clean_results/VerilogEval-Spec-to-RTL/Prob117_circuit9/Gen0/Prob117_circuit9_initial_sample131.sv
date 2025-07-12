module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @(posedge clk) begin
    if (a == 1'b0) begin
        if (q == 3'b111) begin // counter wraps around to 0
            q <= 3'b000;
        end else if (q == 3'b000) begin // first increment from reset
            q <= 3'b001;
        end else begin // general increment
            q <= q + 3'b001;
        end
    end else begin // 'a' is high, hold the current value of q
        if (q == 3'b000 && $rose(a)) begin // special case for reset when a transitions from low to high
            q <= 3'b100;
        end else begin
            q <= q;
        end
    end
end

endmodule