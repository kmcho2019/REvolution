module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    // Priority-encoded pattern matching
    if (c & d & ~a & b) begin       // cd=11, ab=01 (distinct 1 in sea of 1s)
        out = 1'b1;
    end
    else if (~c & ~d & a & ~b) begin // cd=00, ab=10 (edge case)
        out = 1'b1;
    end
    else if (c & ~d & ~a & b) begin  // cd=10, ab=01 (another distinct pattern)
        out = 1'b1;
    end
    else if (~a & ~b) begin          // ab=00 covers multiple cases
        out = ~(c & d);              // 0 only when cd=11
    end
    else if (a & b) begin            // ab=11
        out = c | d;                 // 0 only when cd=00
    end
    else begin                       // remaining ab=01 and ab=10 cases
        out = ~( (~c & d & ~a & b) |  // exclude cd=01,ab=01
                 (c & ~d & a & ~b) ); // exclude cd=10,ab=10
    end
end

endmodule