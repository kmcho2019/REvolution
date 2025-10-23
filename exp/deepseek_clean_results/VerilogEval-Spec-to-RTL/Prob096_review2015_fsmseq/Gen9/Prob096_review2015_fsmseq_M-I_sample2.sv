module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Gray-coded state encoding for minimal transitions
    localparam [1:0] S0 = 2'b00,  // No match
                     S1 = 2'b01,  // '1'
                     S2 = 2'b11,  // '11'
                     S3 = 2'b10;  // '110'

    reg [1:0] state, next_state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            found <= 1'b0;
        end else if (!found) begin
            state <= next_state;
            found <= (state == S3) && (data == 1'b1);
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    assign start_shifting = found;

endmodule