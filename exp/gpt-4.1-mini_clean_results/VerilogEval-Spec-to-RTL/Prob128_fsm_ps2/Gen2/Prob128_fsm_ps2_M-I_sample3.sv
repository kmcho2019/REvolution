module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // One-hot states: search, byte2, byte3, done_pulse
    reg state_search;
    reg state_byte2;
    reg state_byte3;
    reg state_done;

    // done asserted only in DONE state (one cycle pulse)
    assign done = state_done;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, only SEARCH state active
            state_search <= 1'b1;
            state_byte2  <= 1'b0;
            state_byte3  <= 1'b0;
            state_done   <= 1'b0;
        end else begin
            case (1'b1)
                state_search: begin
                    if (in[3]) begin
                        // Found first byte with in[3]=1, move to BYTE2
                        state_search <= 1'b0;
                        state_byte2  <= 1'b1;
                        state_byte3  <= 1'b0;
                        state_done   <= 1'b0;
                    end else begin
                        // Stay in SEARCH
                        state_search <= 1'b1;
                        state_byte2  <= 1'b0;
                        state_byte3  <= 1'b0;
                        state_done   <= 1'b0;
                    end
                end

                state_byte2: begin
                    // On next byte, move to BYTE3
                    state_search <= 1'b0;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b1;
                    state_done   <= 1'b0;
                end

                state_byte3: begin
                    // After third byte, assert done in next cycle
                    state_search <= 1'b0;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b0;
                    state_done   <= 1'b1;
                end

                state_done: begin
                    // After done pulse, return to SEARCH for next message
                    state_search <= 1'b1;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b0;
                    state_done   <= 1'b0;
                end

                default: begin
                    // Safety default: go to SEARCH
                    state_search <= 1'b1;
                    state_byte2  <= 1'b0;
                    state_byte3  <= 1'b0;
                    state_done   <= 1'b0;
                end
            endcase
        end
    end

endmodule