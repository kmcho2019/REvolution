module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // synchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoded states (5 bits)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        // Default assignment
        next_state = IDLE;

        case (state)
            IDLE: begin
                // Wait for '1' to start sequence detection
                next_state = (data_in == 1'b1) ? S1 : IDLE;
            end
            S1: begin
                // Next bit should be '0' for "10"
                next_state = (data_in == 1'b0) ? S2 : S1;
            end
            S2: begin
                // Next bit should be '0' for "100"
                next_state = (data_in == 1'b0) ? S3 : IDLE;
            end
            S3: begin
                // Final bit '1' for "1001"
                next_state = (data_in == 1'b1) ? S4 : IDLE;
            end
            S4: begin
                // After detection, restart sequence detection with overlapping allowed
                next_state = (data_in == 1'b1) ? S1 : IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic - Moore machine: output depends only on state
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule