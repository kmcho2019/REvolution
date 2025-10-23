module TopModule (
    input  in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    always @(*) begin
        // default next_state to zero vector
        next_state = 4'b0000;
        out = 1'b0;

        // Determine output based on current state
        // Output is 1 only in state D (state[3])
        if (state[3]) begin
            out = 1'b1;
        end else begin
            out = 1'b0;
        end

        // Determine next state based on current one-hot state and input
        if (state[0]) begin // State A
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b0010; // B
        end else if (state[1]) begin // State B
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
        end else if (state[2]) begin // State C
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b1000; // D
        end else if (state[3]) begin // State D
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
        end else begin
            // Undefined state: default to A
            next_state = 4'b0001;
            out = 1'b0;
        end
    end

endmodule