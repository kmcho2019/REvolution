module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg reset_detected;
reg prev_p;

always @(negedge clock) begin
    reset_detected <= a;
end

always @(posedge clock) begin
    if (reset_detected) begin
        p <= 0;
        q <= 0;
    end
    else begin
        if (!q) begin
            p <= a;
        end
        else begin
            p <= 0;
        end
        
        q <= prev_p;
    end
    
    prev_p <= p;
end

initial begin
    p = 1'bx;
    q = 1'bx;
    reset_detected = 0;
    prev_p = 0;
end

endmodule