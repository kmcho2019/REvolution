module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States representing progress through the sequence 1101
    localparam [2:0] IDLE = 3'b000,
                     S1   = 3'b001,  // Matched '1'
                     S2   = 3'b010,  // Matched '11'
                     S3   = 3'b011,  // Matched '110'
                     DONE = 3'b100;  // Matched '1101'

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S2 : IDLE;
            S2:   next_state = data ? S2 : S3;
            S3:   next_state = data ? DONE : IDLE;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output is high when in DONE state
    assign start_shifting = (state == DONE);

endmodule