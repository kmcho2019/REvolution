module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;  // Stores p from previous cycle
reg reset_condition;  // Tracks if we need to reset

always @(posedge clock) begin
    // Check reset condition (a was high during low phase)
    reset_condition <= ~clock & a;
    
    if (reset_condition) begin
        p <= 0;
        q <= 0;
    end
    else begin
        if (q) begin
            p <= 0;  // Keep p low when q is high
        end
        else begin
            p <= a;  // p follows a when q is low
        end
        
        // q becomes 1 one cycle after p was 1
        q <= prev_p;
    end
    
    prev_p <= p;  // Store previous p value
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
    reset_condition = 0;
end

endmodule