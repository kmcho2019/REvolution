module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    reg A, B, C, D;
    reg next_A, next_B, next_C, next_D;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
        end else begin
            A <= next_A;
            B <= next_B;
            C <= next_C;
            D <= next_D;
        end
    end

    // Next-state logic with priority: r[0] > r[1] > r[2]
    always @(*) begin
        // Default all next states to 0
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        if (A) begin
            if (r[0])
                next_B = 1'b1;
            else if (r[1])
                next_C = 1'b1;
            else if (r[2])
                next_D = 1'b1;
            else
                next_A = 1'b1;
        end else if (B) begin
            if (r[0])
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else if (C) begin
            if (r[1])
                next_C = 1'b1;
            else
                next_A = 1'b1;
        end else if (D) begin
            if (r[2])
                next_D = 1'b1;
            else
                next_A = 1'b1;
        end else begin
            // Should not happen, but reset to A for safety
            next_A = 1'b1;
        end
    end

    // Output grant signals based on current state (one-hot decoding)
    always @(*) begin
        g = 3'b000;
        if (B)       g = 3'b001; // grant to device 0
        else if (C)  g = 3'b010; // grant to device 1
        else if (D)  g = 3'b100; // grant to device 2
    end

endmodule