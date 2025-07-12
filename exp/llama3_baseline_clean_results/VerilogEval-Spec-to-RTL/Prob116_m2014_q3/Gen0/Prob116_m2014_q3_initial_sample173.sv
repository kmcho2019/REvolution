module TopModule(
    input  [3:0] x, // Note: Adjusted x to match 4-bit requirement
    output reg f
);

always @(*) begin
    // When x[3] is 1, f is generally 1, except for a specific condition
    if (x[3]) begin
        if (x[2] && !x[1]) // This condition does not affect our output directly
            f = 1;
        else if (!x[2] && x[1])
            f = 1;
        else if (!x[2] && !x[1]) // Covers all cases where x[3] = 1 and x[2] = 0
            f = 1;
        else // x[2] = 1 and x[1] = 1 or x[2] = 1 and x[1] = 0
            f = x[1] ? 1 : 0; // Corrected to handle all x[3]=1 cases properly
    end
    else begin // x[3] is 0
        if (x[1] && x[2])
            f = 1;
        else
            f = 0;
    end
end

endmodule