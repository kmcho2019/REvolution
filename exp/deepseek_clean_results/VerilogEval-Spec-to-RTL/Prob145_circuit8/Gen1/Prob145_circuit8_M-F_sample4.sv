module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] a_history;
reg [1:0] p_history;

always @(posedge clock) begin
    // Shift in new a value
    a_history <= {a_history[0], a};
    
    // Update p: high only if we've seen two consecutive a=1 on clock edges
    p <= (a_history == 2'b11);
    
    // Update q: high only if p has been high for two consecutive cycles
    p_history <= {p_history[0], p};
    q <= (p_history == 2'b11);
end

// Synchronous reset when a=1 during non-clock edges
always @(negedge clock) begin
    if (a) begin
        p <= 0;
        q <= 0;
        a_history <= 0;
        p_history <= 0;
    end
end

endmodule