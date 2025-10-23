module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_sampled;

always @(posedge clock) begin
    // Sample 'a' directly during clock high for p
    p <= a;
    p_sampled <= a;
end

always @(negedge clock) begin
    // Set q to previous p value during clock low
    q <= p_sampled;
    
    // Clear conditions
    if (~a) begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule