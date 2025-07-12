module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg reset_condition;

always @(negedge clock) begin
    reset_condition <= a;
end

always @(posedge clock) begin
    if (reset_condition) begin
        p <= 0;
        q <= 0;
    end
    else begin
        if (!q) begin
            p <= a;
        end
        else begin
            p <= 0;
        end
        q <= p;
    end
end

initial begin
    p = 0;
    q = 0;
    reset_condition = 0;
end

endmodule