module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (clock) begin // high clock phase
        p <= a;
    end else begin // low clock phase
        if (a) begin // reset condition for q
            q <= 0;
        end else if (p) begin // update q based on p
            q <= 1;
        end
    end
end

endmodule