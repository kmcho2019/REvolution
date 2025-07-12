module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    // One-hot state bit aliases for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    always @* begin
        // Default outputs
        next_state = 4'b0000;
        out = 1'b0;

        // Determine next_state based on current state and input
        if (A) begin
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b0010; // B
            out = 1'b0;
        end else if (B) begin
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
            out = 1'b0;
        end else if (C) begin
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b1000; // D
            out = 1'b0;
        end else if (D) begin
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
            out = 1'b1;
        end else begin
            // Default fallback (should not happen in well-formed one-hot state)
            next_state = 4'b0001; // reset to A by default
            out = 1'b0;
        end
    end

endmodule