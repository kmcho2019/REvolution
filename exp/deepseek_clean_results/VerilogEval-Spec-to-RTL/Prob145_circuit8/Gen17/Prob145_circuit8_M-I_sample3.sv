module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;  // Stores p from previous cycle

always @(posedge clock) begin
    if (a && ~clock) begin  // Reset condition when a is high during clock low
        p <= 0;
        q <= 0;
    end else begin
        if (q) begin
            p <= 0;  // Keep p low when q is high
        end else begin
            p <= a;  // p follows a when q is low
        end
        
        // q becomes 1 one cycle after p was 1
        q <= p_prev;
    end
    
    p_prev <= p;  // Store previous p value
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule