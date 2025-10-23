module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot state encoding for states detecting "1101"
    localparam S0    = 4'b0001; // no bits matched
    localparam S1    = 4'b0010; // matched '1'
    localparam S11   = 4'b0100; // matched '11'
    localparam S110  = 4'b1000; // matched '110'

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            if (start_shifting) begin
                // Once start_shifting is set, maintain it and no need to track states
                start_shifting <= 1'b1;
                state <= S0; // optionally keep FSM in S0 or freeze state
            end else begin
                case (state)
                    S0: begin
                        if (data)
                            state <= S1;
                        else
                            state <= S0;
                    end
                    S1: begin
                        if (data)
                            state <= S11;
                        else
                            state <= S0;
                    end
                    S11: begin
                        if (data)
                            state <= S11;    // still matching '11' prefix if input is 1
                        else
                            state <= S110;   // matched '110'
                    end
                    S110: begin
                        if (data) begin
                            start_shifting <= 1'b1; // sequence 1101 matched
                            state <= S0;
                        end else begin
                            state <= S0;
                        end
                    end
                    default: state <= S0;
                endcase
            end
        end
    end

endmodule