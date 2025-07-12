module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    // One-hot encoded states
    localparam S0   = 4'b0001; // no match
    localparam S1   = 4'b0010; // matched '1'
    localparam S11  = 4'b0100; // matched '11'
    localparam S110 = 4'b1000; // matched '110'

    reg [3:0] state, next_state;
    reg       detected_next;

    // Combinational logic for next state and detection signal
    always @(*) begin
        next_state = state;     // Default to hold state
        detected_next = 1'b0;  // Default no detection

        case (state)
            S0: begin
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S0;
            end
            S11: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S110;
            end
            S110: begin
                if (data) begin
                    next_state = S1;
                    detected_next = 1'b1;  // Sequence detected at this transition
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Sequential logic for start_shifting output
    // Latch to 1 when detection occurs, reset to 0 on reset
    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (detected_next) begin
            start_shifting <= 1'b1;
        end
    end

endmodule