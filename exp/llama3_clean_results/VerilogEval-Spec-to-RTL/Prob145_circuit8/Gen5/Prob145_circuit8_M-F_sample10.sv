module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (~clock) begin // low clock phase
        if (a == 1'b1) begin // reset condition
            q <= 0;
        end else if (p == 1'b1) begin
            q <= 1'b1;
        end
    end else begin // high clock phase
        p <= a;
    end
end

endmodule