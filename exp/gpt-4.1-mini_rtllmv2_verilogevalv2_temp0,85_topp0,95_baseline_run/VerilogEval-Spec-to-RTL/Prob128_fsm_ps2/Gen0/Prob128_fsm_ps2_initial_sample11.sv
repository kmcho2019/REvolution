module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // State encoding
    localparam IDLE  = 2'd0,
               BYTE2 = 2'd1,
               BYTE3 = 2'd2;

    reg [1:0] state, next_state;
    reg done_reg;

    assign done = done_reg;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            // done is only asserted for one cycle after third byte
            if (state == BYTE3)
                done_reg <= 1'b1;
            else
                done_reg <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end

            BYTE2: begin
                // Accept second byte unconditionally, move to BYTE3
                next_state = BYTE3;
            end

            BYTE3: begin
                // After third byte and done asserted, back to IDLE for new message search
                if (in[3] == 1'b1)
                    // If current byte has bit 3=1, it is start of next message
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule