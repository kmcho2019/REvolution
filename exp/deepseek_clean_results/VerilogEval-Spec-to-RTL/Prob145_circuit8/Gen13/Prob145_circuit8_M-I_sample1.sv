module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_reg;

// Register input 'a' on clock edges
always @(posedge clock) begin
    a_reg <= a;
end

// Synchronous behavior for p and q
always @(posedge clock) begin
    if (~q) begin
        p <= a_reg;  // p follows a_reg when q is 0
    end
    
    if (p && ~q) begin
        q <= 1'b1;   // q sets when p was high and q was 0
    end
end

// Asynchronous reset for q when clock is low and a is high
always @(a or clock) begin
    if (~clock && a) begin
        q <= 1'b0;
    end
end

initial begin
    p = 0;
    q = 0;
    a_reg = 0;
end

endmodule