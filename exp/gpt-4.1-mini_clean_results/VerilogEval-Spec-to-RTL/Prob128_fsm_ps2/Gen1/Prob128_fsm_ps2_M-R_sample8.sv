module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // One-hot state bits
    reg state_search;
    reg state_byte2;
    reg state_byte3;

    // done is asserted when in BYTE3 state
    assign done = state_byte3;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, only SEARCH state active
            state_search <= 1'b1;
            state_byte2  <= 1'b0;
            state_byte3  <= 1'b0;
        end else begin
            // Default next states are zero
            // Compute next states based on current state and input
            case (1'b1)
                state_search: begin
                    if (in[3] == 1'b1) begin
                        // Found first byte with in[3]=1, move to BYTE2
                        state_search <= 1'b0;
                        state_byte2  <= 1'b1;
                        state_byte3  <= 1'b0;
                    end else begin
                        // Stay in SEARCH
                        state_search <= 1'b1;
                        state_byte2  <= 1'b0;
                        state_byte3  <= 1'b0;
                    end
                end

                state_byte2: begin
                    // On next byte, move to BYTE3
                    state_search <= 1'b0;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b1;
                end

                state_byte3: begin
                    // After BYTE3, return to SEARCH to find next message
                    state_search <= 1'b1;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b0;
                end

                default: begin
                    // Safety default: go to SEARCH
                    state_search <= 1'b1;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b0;
                end
            endcase
        end
    end

endmodule