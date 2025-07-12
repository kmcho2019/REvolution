module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    localparam S0   = 2'b00;
    localparam S1   = 2'b01;
    localparam S11  = 2'b10;
    localparam S110 = 2'b11;

    reg [1:0] state, next_state;

    always @(*) begin
        case(state)
            S0:   next_state = data ? S1   : S0;
            S1:   next_state = data ? S11  : S0;
            S11:  next_state = data ? S11  : S110;
            S110: next_state = data ? S1   : S0;  // Continue tracking for overlapping patterns
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // When sequence '1101' detected: current state S110 and data=1
            if (state == S110 && data == 1'b1)
                start_shifting <= 1'b1;
            else if (start_shifting)
                start_shifting <= 1'b1;  // latch start_shifting once set
        end
    end

endmodule