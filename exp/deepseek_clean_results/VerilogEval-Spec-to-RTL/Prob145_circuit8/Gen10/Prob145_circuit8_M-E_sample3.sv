module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg clock_prev;
reg p_delayed;

always @(*) begin
    // Detect rising edge of 'a' during clock high phase
    if (clock && ~clock_prev) begin
        // Start of clock high phase
        a_prev <= a;
    end
    else if (clock) begin
        // During clock high phase
        p <= (~a_prev && a);
        a_prev <= a;
    end
    else begin
        // Clock low phase
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    // Store p from previous clock high phase
    p_delayed <= p;
    
    // Update q based on delayed p
    if (p_delayed) begin
        q <= ~q;
    end
    
    // Track clock phase
    clock_prev <= clock;
end

initial begin
    p = 1'b0;
    q = 1'b0;
    a_prev = 1'b0;
    clock_prev = 1'b0;
    p_delayed = 1'b0;
end

endmodule