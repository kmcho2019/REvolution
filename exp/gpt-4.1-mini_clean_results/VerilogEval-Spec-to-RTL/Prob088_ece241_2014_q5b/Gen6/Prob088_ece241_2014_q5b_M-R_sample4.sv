module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state bits
    reg state_A, state_B;
    reg next_A, next_B;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Next-state logic
    always @(*) begin
        // Default no change
        next_A = state_A;
        next_B = state_B;

        if (state_A) begin
            // From A: go to B if x==1, else stay in A
            if (x) begin
                next_A = 1'b0;
                next_B = 1'b1;
            end else begin
                next_A = 1'b1;
                next_B = 1'b0;
            end
        end else if (state_B) begin
            // From B: always remain in B
            next_A = 1'b0;
            next_B = 1'b1;
        end
    end

    // Output logic (Mealy): 
    // z=1 when (state==A & x==1) or (state==B & x==0), else 0
    assign z = (state_A & x) | (state_B & ~x);

endmodule