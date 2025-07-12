module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    reg s0, s1, s2, s3, s4;
    wire next_s0, next_s1, next_s2, next_s3, next_s4;

    // Next state logic
    assign next_s0 = (~reset & ((s0 & ~x) | (s2 & ~x) | (s3 & x)));
    assign next_s1 = (~reset & ((s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x)));
    assign next_s2 = (~reset & ((s3 & x) | (s4 & ~x) | (s2 & ~x)));
    assign next_s3 = (~reset & (s4 & ~x));
    assign next_s4 = (~reset & ((s1 & x) | (s4 & x)));

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            s0 <= 1'b1;
            s1 <= 1'b0;
            s2 <= 1'b0;
            s3 <= 1'b0;
            s4 <= 1'b0;
            z <= 1'b0;
        end else begin
            s0 <= next_s0;
            s1 <= next_s1;
            s2 <= next_s2;
            s3 <= next_s3;
            s4 <= next_s4;
            z <= s3 | s4;  // Registered output
        end
    end

endmodule