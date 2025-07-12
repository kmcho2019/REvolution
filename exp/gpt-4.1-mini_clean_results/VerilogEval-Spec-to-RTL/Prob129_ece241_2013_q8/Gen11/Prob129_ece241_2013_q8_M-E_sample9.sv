module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding: only one of these is '1' at a time
    reg s0, s1, s2;

    // Asynchronous negative edge reset, synchronous state transition and output logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            // Reset all states to initial
            s0 <= 1'b1;  // Initial state: no bits matched
            s1 <= 1'b0;
            s2 <= 1'b0;
            z  <= 1'b0;
        end else begin
            // Default output is 0; will set to 1 if sequence detected
            z <= 1'b0;
            // State transitions based on current state and input x
            case ({s2, s1, s0})
                3'b001: begin // S0: no bits matched
                    if (x) begin
                        s0 <= 1'b0;
                        s1 <= 1'b1;  // matched '1'
                        s2 <= 1'b0;
                    end else begin
                        s0 <= 1'b1;
                        s1 <= 1'b0;
                        s2 <= 1'b0;
                    end
                end

                3'b010: begin // S1: matched '1'
                    if (!x) begin
                        s0 <= 1'b0;
                        s1 <= 1'b0;
                        s2 <= 1'b1;  // matched "10"
                    end else begin
                        s0 <= 1'b0;
                        s1 <= 1'b1;  // remain in S1, got another '1'
                        s2 <= 1'b0;
                    end
                end

                3'b100: begin // S2: matched "10"
                    if (x) begin
                        // sequence "101" detected here (S2 + x=1)
                        z  <= 1'b1;
                        s0 <= 1'b0;
                        s1 <= 1'b1;  // Next state corresponds to matched '1' for overlap
                        s2 <= 1'b0;
                    end else begin
                        s0 <= 1'b1;  // no match if input is 0, back to initial
                        s1 <= 1'b0;
                        s2 <= 1'b0;
                    end
                end

                default: begin
                    // In case of illegal state, reset to initial
                    s0 <= 1'b1;
                    s1 <= 1'b0;
                    s2 <= 1'b0;
                    z  <= 1'b0;
                end
            endcase
        end
    end

endmodule