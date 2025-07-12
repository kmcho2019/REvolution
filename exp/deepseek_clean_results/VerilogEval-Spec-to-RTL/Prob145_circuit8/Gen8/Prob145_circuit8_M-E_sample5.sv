module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_delayed;

// Detect rising edges of 'a' during clock high
wire a_rise = ~a_prev & a;

always @(posedge clock) begin
    a_prev <= a;
    
    // Set p only on rising edge of 'a' during clock high
    if (a_rise) begin
        p <= 1'b1;
    end
    else begin
        p <= 1'b0;
    end
    
    // Store previous p for q generation
    p_delayed <= p;
end

always @(negedge clock) begin
    // Set q if p was high in previous clock high phase
    if (p_delayed) begin
        q <= 1'b1;
    end
    // Clear q when 'a' is low during clock low
    else if (~a) begin
        q <= 1'b0;
    end
end

endmodule