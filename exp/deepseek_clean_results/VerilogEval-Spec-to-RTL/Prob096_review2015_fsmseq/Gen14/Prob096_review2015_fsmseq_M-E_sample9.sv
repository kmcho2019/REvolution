module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States encoding
    localparam S0 = 3'b000; // Initial state
    localparam S1 = 3'b001; // Matched '1'
    localparam S2 = 3'b010; // Matched '11'
    localparam S3 = 3'b011; // Matched '110'
    localparam S4 = 3'b100; // Pattern matched (1101)

    reg [2:0] state, next_state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            found <= 1'b0;
        end else if (!found) begin
            state <= next_state;
            found <= (next_state == S4);
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3; // Early termination if we get '1' here
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;
            default: next_state = S0;
        endcase
    end

    assign start_shifting = found;

endmodule