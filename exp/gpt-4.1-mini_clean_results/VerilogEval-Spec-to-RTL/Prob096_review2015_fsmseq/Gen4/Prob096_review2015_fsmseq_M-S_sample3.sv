module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States encoding (2 bits)
    localparam IDLE = 2'b00;  // no match
    localparam S1   = 2'b01;  // matched '1'
    localparam S11  = 2'b10;  // matched '11'
    localparam S110 = 2'b11;  // matched '110'

    reg [1:0] state, next_state;
    reg detected;

    always @(*) begin
        if (detected) begin
            // Once detected, remain detected regardless of input
            next_state = state;
        end else begin
            case(state)
                IDLE:    next_state = data ? S1 : IDLE;
                S1:      next_state = data ? S11 : IDLE;
                S11:     next_state = data ? S11 : S110;
                S110:    next_state = data ? IDLE : IDLE; // data=1 triggers detection, else restart
                default: next_state = IDLE;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            detected <= 1'b0;
        end else begin
            state <= next_state;
            // Detect sequence when in S110 and data=1 at next clock
            if (!detected && state == S110 && data)
                detected <= 1'b1;
        end
    end

    assign start_shifting = detected;

endmodule