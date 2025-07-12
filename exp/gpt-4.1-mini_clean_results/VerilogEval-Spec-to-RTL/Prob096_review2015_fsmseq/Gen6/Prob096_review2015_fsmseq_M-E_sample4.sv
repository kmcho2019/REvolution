module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (3 bits for clarity)
    localparam [2:0]
        S0    = 3'd0, // no bits matched
        S1    = 3'd1, // matched '1'
        S11   = 3'd2, // matched '11'
        S110  = 3'd3, // matched '110'
        S_DET = 3'd4; // detected sequence (optional, to stay in detect state)

    reg [2:0] state, next_state;
    wire detected;

    // Combinational next state and detection logic (Mealy)
    always @(*) begin
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
                    next_state = S11;  // '111' partial, keep in S11
                else
                    next_state = S110;
            end
            S110: begin
                if (data)
                    next_state = S1;   // sequence 1101 detected on this input
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Detection signal (Mealy output): detected on transition from S110 on input=1
    assign detected = (state == S110) && (data == 1'b1);

    // State register and start_shifting latch, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting forever once detected
            if (detected)
                start_shifting <= 1'b1;
        end
    end

endmodule