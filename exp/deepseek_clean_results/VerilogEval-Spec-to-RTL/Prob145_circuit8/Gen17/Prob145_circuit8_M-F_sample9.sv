module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_at_posedge;

always @(posedge clock) begin
    a_prev <= a;
    // Detect rising edge of a during high clock
    if (~a_prev && a) begin
        p <= 1'b1;
    end
    else begin
        p <= 1'b0;
    end
    // Store p's value at positive edge for q
    p_at_posedge <= p;
end

always @(negedge clock) begin
    // q becomes 1 if p was 1 at previous positive edge
    if (p_at_posedge) begin
        q <= 1'b1;
    end
    else begin
        q <= 1'b0;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
    a_prev = 1'b0;
    p_at_posedge = 1'b0;
end

endmodule