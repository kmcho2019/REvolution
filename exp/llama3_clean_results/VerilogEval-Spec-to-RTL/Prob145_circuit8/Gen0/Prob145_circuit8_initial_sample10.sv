module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg q_int;

always @(posedge clock) begin
    q_int <= a;
end

always @(posedge clock or negedge clock) begin
    if (clock == 1) begin
        p <= a;
    end else begin
        q <= q_int;
    end
end

always @(posedge clock or negedge clock) begin
    if (clock == 1) begin
        q <= q_int;
    end else if (a == 1) begin
        q <= 1;
    end else begin
        q <= q;
    end
end

endmodule