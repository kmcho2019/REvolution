module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// Combinational logic for p
assign p = clock & a;

// Sequential logic for q
reg p_prev;

always @(posedge clock) begin
    p_prev <= p;  // Capture p value at posedge
end

always @(negedge clock) begin
    if (p_prev) begin
        q <= 1'b1;  // Set q if p was high in previous high phase
    end
    else if (~a) begin
        q <= 1'b0;  // Clear q if a is low during low phase
    end
end

endmodule