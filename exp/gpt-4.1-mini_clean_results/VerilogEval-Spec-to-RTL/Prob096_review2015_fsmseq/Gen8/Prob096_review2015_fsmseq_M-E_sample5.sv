module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding for Mealy FSM (binary)
    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'

    reg [2:0] state, next_state;
    reg detected_next;

    // Next state and detection logic (Mealy)
    always @(*) begin
        next_state = S0;
        detected_next = start_shifting; // default to hold current detected value

        case(state)
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
                if (~data)
                    next_state = S3;
                else
                    next_state = S2;
            end
            S3: begin
                if (data) begin
                    next_state = S1; // because last input is '1', start new match
                    detected_next = 1'b1; // sequence 1101 found here (Mealy output)
                end
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // State and output register update synchronous with clk and reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            start_shifting <= detected_next;
        end
    end

endmodule