module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic using assign statements (combinational)
    wire next_IDLE, next_S1, next_S2, next_S3, next_S4;

    // IDLE: wait for '1'
    assign next_IDLE = (state == IDLE) && ~data_in;
    // S1: matched '1', expect '0'
    assign next_S1 = ((state == IDLE) && data_in) || ((state == S1) && data_in) || ((state == S4) && data_in);
    // S2: matched '10', expect '0'
    assign next_S2 = (state == S1) && ~data_in;
    // S3: matched '100', expect '1'
    assign next_S3 = (state == S2) && ~data_in;
    // S4: matched '1001' detected
    assign next_S4 = (state == S3) && data_in;

    always @(*) begin
        next_state = 5'b00000;

        if (next_IDLE)
            next_state = IDLE;
        else if (next_S1)
            next_state = S1;
        else if (next_S2)
            next_state = S2;
        else if (next_S3)
            next_state = S3;
        else if (next_S4)
            next_state = S4;
        else
            // if no condition met, fall back to IDLE to avoid latch inferred
            next_state = IDLE;
    end

    // State register and output with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted when in S4 state (Moore output)
            sequence_detected <= (next_state == S4);
        end
    end

endmodule