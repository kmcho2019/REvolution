module fsm(
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Sequence to detect: 1 0 0 1 1
    localparam SEQ_LEN = 5;
    reg [2:0] state, next_state; // state counts matched prefix length (0 to 5)

    // Combinational next state logic
    // Based on current state and input, calculate next state:
    // We attempt to match the longest prefix suffix for overlap detection.
    always @(*) begin
        // Default MATCH low
        MATCH = 1'b0;
        case(state)
            3'd0: next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN == 1'b0) ? 3'd2 : (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd2: next_state = (IN == 1'b0) ? 3'd3 : (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd3: next_state = (IN == 1'b1) ? 3'd4 : 3'd0;
            3'd4: begin
                if(IN == 1'b1) begin
                    next_state = 3'd5;
                    MATCH = 1'b1; // Full sequence matched here
                end else
                    next_state = 3'd2; // Partial overlap matched at prefix length 2
            end
            3'd5: begin
                // After full match, check input for overlap detection restart:
                // If next input is 1, state=1 else 0
                next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
                MATCH = 1'b0;
            end
            default: next_state = 3'd0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if(RST) begin
            state <= 3'd0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule