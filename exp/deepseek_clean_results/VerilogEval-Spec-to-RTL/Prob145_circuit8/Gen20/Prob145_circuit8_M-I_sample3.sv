module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg p_delayed;

always @(posedge clock) begin
    // Detect rising edge of 'a' and set p
    if (a && !prev_a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
    prev_a <= a;
    
    // Store p value for q generation
    p_delayed <= p;
end

always @(negedge clock) begin
    // Set q one cycle after p was high
    q <= p_delayed;
end

initial begin
    prev_a = 1'b0;
    p = 1'b0;
    q = 1'b0;
    p_delayed = 1'b0;
end

endmodule