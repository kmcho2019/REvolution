module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (3-bit)
    localparam S0   = 3'd0; // no match
    localparam S1   = 3'd1; // matched '1'
    localparam S11  = 3'd3; // matched '11'
    localparam S110 = 3'd2; // matched '110'

    reg [2:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            S0:   next_state = data ? S1 : S0;
            S1:   next_state = data ? S11 : S0;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state register and start_shifting output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting when full sequence 1101 detected (on S110 + data=1)
            if (state == S110 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule