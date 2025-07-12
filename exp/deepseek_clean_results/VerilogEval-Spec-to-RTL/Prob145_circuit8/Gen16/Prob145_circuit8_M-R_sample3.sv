module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a && !clock) begin  // Reset condition when a is high during low phase
        p <= 0;
        q <= 0;
    end
    else begin
        if (!q) begin
            p <= a;         // p follows a when q is low
        end
        else begin
            p <= 0;         // p stays 0 when q is high
        end
        q <= p;             // q is always previous p value
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule