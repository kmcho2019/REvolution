module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot encoded states - 6 states:
    // S0: no match yet
    // S1: matched '1'
    // S2: matched "11"
    // S3: matched "110"
    // S4: detected "1101" (set output)
    // S5: latched final state to hold start_shifting forever
    localparam S0 = 6'b000001,
               S1 = 6'b000010,
               S2 = 6'b000100,
               S3 = 6'b001000,
               S4 = 6'b010000,
               S5 = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Output logic: start_shifting goes high when entering S4 or is held in S5
            if (next_state == S4 || state == S5)
                start_shifting <= 1'b1;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S5; // Once detected, latch output next cycle
            S5: next_state = S5; // Hold final state forever
            default: next_state = S0;
        endcase
    end

endmodule