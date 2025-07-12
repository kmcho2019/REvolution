module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding with parameters
    localparam S0   = 2'd0; // no match
    localparam S1   = 2'd1; // matched '1'
    localparam S11  = 2'd2; // matched '11'
    localparam S110 = 2'd3; // matched '110'

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
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
                        state <= S11;
                    else
                        state <= S110;
                end
                S110: begin
                    if (data) begin
                        state <= S1;
                        start_shifting <= 1'b1; // sequence detected here
                    end else
                        state <= S0;
                end
                default: state <= S0;
            endcase
            // start_shifting remains set once asserted until reset
        end
    end

endmodule