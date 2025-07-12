module TopModule(
    input  a,
    input  b,
    output out
);
    
    // The current implementation is already efficient, but for clarity and readability,
    // we could consider using a case statement, though it's unlikely to improve PPA metrics.
    // assign out = ~(a | b);
    
    // Alternative implementation for clarity and explicitness, though not expected to improve PPA.
    always @(*) begin
        if (a == 1'b0 && b == 1'b0) begin
            out = 1'b1;
        end else begin
            out = 1'b0;
        end
    end
    
endmodule