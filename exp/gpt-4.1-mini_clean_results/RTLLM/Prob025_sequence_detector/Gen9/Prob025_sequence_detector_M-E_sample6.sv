module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // asynchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (one-hot)
    localparam IDLE = 5'b00001, // No bits matched yet
               S1   = 5'b00010, // matched '1'
               S10  = 5'b00100, // matched "10"
               S100 = 5'b01000, // matched "100"
               S1001= 5'b10000; // matched "1001" (final)

    reg [4:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic - Moore FSM transitions
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for first '1' bit
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                // From '1', expect '0'
                if (!data_in)
                    next_state = S10;
                else
                    next_state = S1; // still '1', could start sequence again
            end
            S10: begin
                // From "10", expect '0'
                if (!data_in)
                    next_state = S100;
                else
                    next_state = S1; // '1' detected, restart from S1
            end
            S100: begin
                // From "100", expect '1'
                if (data_in)
                    next_state = S1001;
                else
                    next_state = IDLE; // wrong bit, back to IDLE
            end
            S1001: begin
                // Sequence detected, output asserted on this state
                // Overlap handling: next state depends on current data_in
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic - registered output asserted when in S1001 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S1001);
    end

endmodule