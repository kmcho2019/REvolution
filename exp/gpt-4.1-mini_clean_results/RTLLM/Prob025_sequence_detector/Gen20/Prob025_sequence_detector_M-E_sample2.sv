module sequence_detector (
    input  wire clk,
    input  wire reset,         // Synchronous active-high reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoded states
    localparam IDLE   = 5'b00001,
               S1     = 5'b00010,
               S10    = 5'b00100,
               S100   = 5'b01000,
               S1001  = 5'b10000;

    reg [4:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic: Moore FSM transitions for sequence "1001"
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S10;
                else
                    next_state = S1; // Remain if '1' (possible overlapping)
            end
            S10: begin
                if (data_in == 1'b0)
                    next_state = S100;
                else
                    next_state = S1; // Restart from S1 if '1'
            end
            S100: begin
                if (data_in == 1'b1)
                    next_state = S1001;
                else
                    next_state = IDLE; // Reset if bit does not continue sequence
            end
            S1001: begin
                // sequence detected, output asserted in this state
                // Transition depends on input to detect overlapping sequences:
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted only in S1001 state
    always @(posedge clk) begin
        if (reset)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S1001);
    end

endmodule