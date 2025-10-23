module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output wire [2:0]  g
);

    // One-hot state bits
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (~resetn) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
        end
    end

    // Next state logic with priority encoding in state A
    always @(*) begin
        // Default no state active
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        if (state_A) begin
            // Priority: r0 > r1 > r2
            if (r[0]) begin
                next_B = 1'b1;
            end else if (r[1]) begin
                next_C = 1'b1;
            end else if (r[2]) begin
                next_D = 1'b1;
            end else begin
                next_A = 1'b1;
            end
        end else if (state_B) begin
            // Stay in B if r0=1, else back to A
            if (r[0])
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_C) begin
            // Stay in C if r1=1, else back to A
            if (r[1])
                next_C = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_D) begin
            // Stay in D if r2=1, else back to A
            if (r[2])
                next_D = 1'b1;
            else
                next_A = 1'b1;
        end else begin
            // Safety fallback to A
            next_A = 1'b1;
        end
    end

    // Output grants derived from state bits
    assign g[0] = state_B;
    assign g[1] = state_C;
    assign g[2] = state_D;

endmodule