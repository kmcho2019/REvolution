module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding
    reg [4:0] state;  // IDLE, S1, S2, S3, FOUND

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 5'b00001;  // IDLE
        end else if (state[4]) begin
            state <= 5'b10000;  // Stay in FOUND
        end else begin
            case (1'b1)
                state[0]: state <= data ? 5'b00010 : 5'b00001;  // IDLE -> S1 or IDLE
                state[1]: state <= data ? 5'b00100 : 5'b00001;  // S1 -> S2 or IDLE
                state[2]: state <= data ? 5'b00100 : 5'b01000;  // S2 -> S2 or S3
                state[3]: state <= data ? 5'b10000 : 5'b00001;  // S3 -> FOUND or IDLE
                default:  state <= 5'b00001;
            endcase
        end
    end

    // Output is just the FOUND state bit
    assign start_shifting = state[4];

endmodule