module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding
    localparam S0   = 2'b00;
    localparam S1   = 2'b01;
    localparam S11  = 2'b10;
    localparam S110 = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0:   next_state = data ? S1 : S0;
            S1:   next_state = data ? S11 : S0;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and start_shifting latch
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Detect sequence completion: from S110 + data=1 means 1101 detected
            if (state == S110 && data == 1'b1)
                start_shifting <= 1'b1;
            else if (start_shifting)
                start_shifting <= 1'b1; // latch output high forever until reset
            else
                start_shifting <= 1'b0;
        end
    end

endmodule