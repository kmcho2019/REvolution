module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // no match
        S1 = 2'b01, // matched '1'
        S2 = 2'b10, // matched "11"
        S3 = 2'b11  // matched "110"
    } state_t;

    reg start_shifting_reg;
    reg [1:0] state, next_state;

    // Next state logic and output flag update
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting_reg <= 1'b0;
        end else begin
            state <= next_state;
            // Set start_shifting_reg when sequence 1101 is detected
            if (state == S3 && data == 1'b1)
                start_shifting_reg <= 1'b1;
        end
    end

    assign start_shifting = start_shifting_reg;

endmodule