module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;
wire q_reset = ~clock & a;

always @(posedge clock) begin
    // Update p based on current q state
    if (~q) begin
        p <= a;
    end else begin
        p <= 0;
    end
    
    // Update q based on previous p state
    if (prev_p) begin
        q <= 1;
    end
    
    // Store current p for next cycle
    prev_p <= p;
end

always @(negedge clock or posedge q_reset) begin
    if (q_reset) begin
        q <= 0;
        prev_p <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule