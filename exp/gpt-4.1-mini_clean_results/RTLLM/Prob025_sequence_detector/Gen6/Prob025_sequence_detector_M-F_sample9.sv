module sequence_detector (
    input  wire clk,
    input  wire rst_n,          // Renamed reset port to match testbench convention (active low)
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoding of states for clarity
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // Default to hold current state to prevent unintended transitions
        next_state = state;
        
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
            end
            S1: begin
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1; // Stay if '1' to handle overlapping sequences
            end
            S2: begin
                if (!data_in)
                    next_state = S3;
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            S4: begin
                // After sequence detected, check for overlapping sequences
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: register sequence_detected, asserted one clock cycle when entering S4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
            // Assert when current state is S3 and input is 1 (next state S4)
    end

endmodule