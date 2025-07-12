module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'
    localparam S4 = 3'b100; // matched '1101' (final)

    reg [2:0] state, next_state;

    // Combinational logic to compute next_state
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state update and output register
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Assert start_shifting when in final state and keep it asserted
            if (next_state == S4)
                start_shifting <= 1'b1;
            else
                start_shifting <= start_shifting;
        end
    end

endmodule