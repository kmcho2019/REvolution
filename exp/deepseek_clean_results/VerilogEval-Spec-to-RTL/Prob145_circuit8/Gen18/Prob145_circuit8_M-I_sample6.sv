module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg reset_condition;
reg p_was_high;

always @(negedge clock) begin
    reset_condition <= a;
end

always @(posedge clock) begin
    if (reset_condition) begin
        p <= 0;
        q <= 0;
        p_was_high <= 0;
    end
    else begin
        if (!q) begin
            p <= a;
        end
        
        // Update p_was_high based on current p value
        p_was_high <= p;
        
        // q becomes 1 if p was high for a full cycle
        if (p_was_high) begin
            q <= 1;
        end
    end
end

initial begin
    p = 0;
    q = 0;
    reset_condition = 0;
    p_was_high = 0;
end

endmodule