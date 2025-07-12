module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_prev;

always @(posedge clock or negedge clock) begin
    if (clock) begin
        // Clock high behavior
        p <= (a && !a_prev) ? 1'b1 : 1'b0;
        q <= p_prev;
        p_prev <= p;
        a_prev <= a;
    end
    else begin
        // Clock low behavior - check for reset condition
        if (a && a_prev) begin
            p <= 1'b0;
            q <= 1'b0;
        end
        a_prev <= a;
    end
end

endmodule