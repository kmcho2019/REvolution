module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (2 bits for a Mealy FSM)
    localparam [1:0]
        S0 = 2'b00, // no match yet
        S1 = 2'b01, // matched '1'
        S2 = 2'b10, // matched "11"
        S3 = 2'b11; // matched "110"

    reg [1:0] state, next_state;
    reg detected;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting when detected once
            if (detected)
                start_shifting <= 1'b1;
        end
    end

    // Next-state and detection logic (Mealy FSM)
    always @(*) begin
        next_state = state;
        detected = 1'b0;

        case (state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (data)
                    next_state = S2;
                else
                    next_state = S3;
            end
            S3: begin
                if (data) begin
                    // Sequence "1101" detected on this transition
                    detected = 1'b1;
                    next_state = S1;
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule