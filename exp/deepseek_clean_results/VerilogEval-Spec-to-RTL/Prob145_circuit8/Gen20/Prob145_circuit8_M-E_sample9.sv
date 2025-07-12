module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_delayed;

always @(posedge clock) begin
    a_prev <= a;
    p_delayed <= p;
    
    // q is p delayed by one cycle, but stays high until next p
    if (p) begin
        q <= 1'b1;
    end else if (p_delayed) begin
        q <= 1'b0;
    end
end

// Combinatorial logic for p
always @(*) begin
    if (clock) begin
        p = a && !a_prev;  // rising edge detection during clock high
    end else begin
        p = 1'b0;
    end
end

initial begin
    a_prev = 1'b0;
    p_delayed = 1'b0;
    p = 1'b0;
    q = 1'b0;
end

endmodule