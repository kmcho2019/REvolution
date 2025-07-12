module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding for better timing and simpler next-state logic
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next state and output logic combined for one-hot encoding, blocking assignments
    always @(*) begin
        // Default assignments
        next_state = 5'b00000;
        z = 1'b0;

        case (state)
            S0: begin
                next_state = (x) ? S1 : S0;
                z = 1'b0;
            end
            S1: begin
                next_state = (x) ? S4 : S1;
                z = 1'b0;
            end
            S2: begin
                next_state = (x) ? S1 : S2;
                z = 1'b0;
            end
            S3: begin
                next_state = (x) ? S2 : S1;
                z = 1'b1;
            end
            S4: begin
                next_state = (x) ? S4 : S3;
                z = 1'b1;
            end
            default: begin // Safe recovery to initial state
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset, non-blocking assignment
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule