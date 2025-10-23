module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // Previous value of a

always @(posedge clock) begin
    if (a == 1'b1 && prev_a == 1'b0) begin
        // a has just risen, set p
        p <= 1'b1;
    end else if (a == 1'b0 && prev_a == 1'b1) begin
        // a has just fallen, reset p if it was previously set
        if (p == 1'b1) begin
            p <= 1'b0;
        end
    end
    
    prev_a <= a; // Update previous value of a
end

always @(*) begin
    if (p == 1'b1) begin
        q = 1'b1; // Set q to 1 when p is 1
    end else begin
        q = 1'b0; // Reset q to 0 when p is 0
    end
end

endmodule