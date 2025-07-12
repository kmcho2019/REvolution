module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Implementation using assign statement
    assign out_assign = a & b;
    
    // Implementation using always block
    always @(a or b) begin
        out_alwaysblock = a & b;
    end

    // Lightweight verification (uncomment when needed)
    // always @(*) begin
    //     if (out_assign !== out_alwaysblock) begin
    //         $display("Error: AND gate mismatch at time %t", $time);
    //     end
    // end
endmodule