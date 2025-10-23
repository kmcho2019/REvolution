module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg q_state;

always @(posedge clock) begin
    p <= a;
end

always @(posedge clock or negedge clock) begin
    if (negedge clock) begin
        if (a) begin
            q_state <= 0;
        end
    end else begin
        if (p &&!q_state) begin
            q_state <= 1;
        end
    end
end

always @(*) begin
    if (q_state) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule