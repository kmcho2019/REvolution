module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state; // 0: idle, 1: active

always @(posedge clock) begin
    if (a == 1'b1 && ~clock) begin // reset condition
        state <= 0;
        p <= 0;
        q <= 0;
    end else if (clock == 1'b1) begin // active state
        state <= 1;
        p <= a;
    end else if (clock == 1'b0) begin // idle state
        state <= 0;
        if (p == 1'b1 && a == 1'b0) begin
            q <= 1'b1;
        end else if (a == 1'b1) begin
            q <= 1'b0;
        end
    end
end

endmodule