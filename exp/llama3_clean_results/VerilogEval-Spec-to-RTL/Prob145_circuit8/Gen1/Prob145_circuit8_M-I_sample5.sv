module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state;

always @(posedge clock) begin
    if (a == 1'b1) begin
        p <= 1'b1;
        if (state == 1'b0) begin
            state <= 1'b1;
        end
    end else begin
        if (state == 1'b1) begin
            q <= 1'b1;
        end
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        p <= 1'b0;
        q <= 1'b0;
        state <= 1'b0;
    end
end

endmodule