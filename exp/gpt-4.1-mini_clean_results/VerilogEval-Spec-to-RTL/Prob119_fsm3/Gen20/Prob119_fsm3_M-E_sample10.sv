module TopModule(
    input        clk,
    input        areset,
    input        in,
    output reg   out
);

    // One-hot state encoding for four states
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;    // Asynchronous reset to state A
            out <= 1'b0;
        end else begin
            // Default output 0, set to 1 only in state D
            out <= 1'b0;

            // State update and output logic combined
            if (state == A) begin
                if (in)
                    state <= B;
                else
                    state <= A;
            end else if (state == B) begin
                if (in)
                    state <= B;
                else
                    state <= C;
            end else if (state == C) begin
                if (in)
                    state <= D;
                else
                    state <= A;
            end else if (state == D) begin
                out <= 1'b1; // Output is 1 only in state D
                if (in)
                    state <= B;
                else
                    state <= C;
            end else begin
                // Safety fallback to A if undefined state encountered
                state <= A;
                out <= 1'b0;
            end
        end
    end

endmodule