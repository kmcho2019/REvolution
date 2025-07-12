module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoded states
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

    // Next state logic - combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                // Sequence so far: 1
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;  // Stay in S1 if input is 1 to allow overlapping sequences starting again
            end

            S2: begin
                // Sequence so far: 10
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE; // Reset if sequence breaks here
            end

            S3: begin
                // Sequence so far: 100
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            S4: begin
                // Sequence detected, now check overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted high for one cycle when entering S4
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (next_state == S4);
    end

endmodule