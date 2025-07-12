module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot state encoding for 4 states
    localparam [3:0] S0   = 4'b0001; // no match
    localparam [3:0] S1   = 4'b0010; // matched '1'
    localparam [3:0] S11  = 4'b0100; // matched '11'
    localparam [3:0] S110 = 4'b1000; // matched '110'

    reg [3:0] state, next_state;
    reg sequence_found;

    // Combined next_state and sequence_found logic
    always @(*) begin
        // Default assignments
        next_state = S0;
        sequence_found = 1'b0;

        case (state)
            S0: begin
                next_state = data ? S1 : S0;
            end
            S1: begin
                next_state = data ? S11 : S0;
            end
            S11: begin
                next_state = data ? S11 : S110;
            end
            S110: begin
                if (data) begin
                    sequence_found = 1'b1; // sequence 1101 found on this input '1'
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: state update and start_shifting latch
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting when sequence detected, hold until reset
            if (sequence_found)
                start_shifting <= 1'b1;
        end
    end

endmodule