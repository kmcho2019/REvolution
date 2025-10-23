module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;  // Stores p from previous cycle

always @(posedge clock) begin
    if (q) begin
        p <= 0;  // Keep p low when q is high
        if (a) begin
            q <= 0;  // Reset q if a was high during low phase
        end
    end else begin
        p <= a;  // p follows a when q is low
    end
    
    prev_p <= p;  // Store previous p value
    
    // q becomes 1 one cycle after p was 1
    if (prev_p) begin
        q <= 1;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule