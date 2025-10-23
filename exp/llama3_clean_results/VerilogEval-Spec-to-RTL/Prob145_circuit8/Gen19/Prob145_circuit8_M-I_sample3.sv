module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // Store the previous value of 'a'
reg prev_clock; // Store the previous value of 'clock'

always @(posedge clock) begin
    prev_a <= a;
    prev_clock <= clock;
end

always @(*) begin
    if (!clock) begin
        p = 1'b0;
    end else begin
        p = a;
    end
    
    if (prev_clock && a &&!prev_a) begin
        q = 1'b1;
    end else if (!clock && a) begin
        q = 1'b0;
    end else begin
        q = q;
    end
end

endmodule