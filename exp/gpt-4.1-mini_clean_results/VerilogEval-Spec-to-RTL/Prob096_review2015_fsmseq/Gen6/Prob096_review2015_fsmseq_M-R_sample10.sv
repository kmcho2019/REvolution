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
    reg match_detected;

    // Combinational next state and match_detected logic
    always @(*) begin
        case (state)
            S0:   next_state = data ? S1 : S0;
            S1:   next_state = data ? S11 : S0;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase

        // Detect sequence completion on current input and state
        // The sequence 1101 completes when current state is S110 and input is 1
        match_detected = (state == S110) && (data == 1'b1);
    end

    // Sequential state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (match_detected)
                start_shifting <= 1'b1;
            else
                start_shifting <= start_shifting; // hold the value once set
        end
    end

endmodule