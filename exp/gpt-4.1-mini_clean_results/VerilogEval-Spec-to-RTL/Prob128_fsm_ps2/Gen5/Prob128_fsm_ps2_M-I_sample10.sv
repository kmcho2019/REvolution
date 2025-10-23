module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // One-hot encoded states
    localparam WAIT_BYTE1 = 3'b001,
               BYTE2     = 3'b010,
               BYTE3     = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_BYTE1: begin
                if (in[3])
                    next_state = BYTE2;  // Found start byte
                else
                    next_state = WAIT_BYTE1;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3])
                    next_state = BYTE2;  // Immediately start next message
                else
                    next_state = WAIT_BYTE1; // Wait for next message start
            end
            default: next_state = WAIT_BYTE1;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_BYTE1;
        else
            state <= next_state;
    end

    // done asserted in cycle after receiving 3rd byte
    assign done = (state == BYTE3);

endmodule