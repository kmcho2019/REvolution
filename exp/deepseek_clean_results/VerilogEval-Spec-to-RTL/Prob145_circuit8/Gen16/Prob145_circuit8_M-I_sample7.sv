module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg prev_p;

always @(posedge clock) begin
    prev_p <= p;  // Store previous p value for q update
    
    if (q) begin
        p <= 0;
        if (prev_a) begin
            q <= 0;
        end
    end else begin
        p <= a;
    end
    
    if (!q && prev_p) begin
        q <= 1;
    end
    
    prev_a <= a;  // Sample a for reset condition
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
    prev_a = 0;
end

endmodule