module TopModule(
    input  clk,
    input  shift_ena,
    input  count_ena,
    input  data,
    output [3:0] q
);

reg [3:0] internal_q;

assign q = internal_q;

always @(posedge clk) begin
    if (shift_ena) begin
        internal_q <= {data, internal_q[3:1]};
    end else if (count_ena) begin
        if (internal_q == 0) begin
            internal_q <= internal_q; // stay at 0 when trying to decrement 0
        end else begin
            internal_q <= internal_q - 1;
        end
    end
end

endmodule