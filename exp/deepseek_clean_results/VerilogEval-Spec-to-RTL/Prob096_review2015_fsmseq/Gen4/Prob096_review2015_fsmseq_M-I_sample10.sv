module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam [4:0] 
        IDLE  = 5'b00001,
        S1    = 5'b00010,
        S2    = 5'b00100,
        S3    = 5'b01000,
        FOUND = 5'b10000;

    reg [4:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic - simplified with one-hot
    always @(*) begin
        next_state = IDLE; // Default
        case (1'b1) // Synthesis will optimize this
            current_state[0]: next_state = data ? S1 : IDLE;      // IDLE
            current_state[1]: next_state = data ? S2 : IDLE;      // S1
            current_state[2]: next_state = data ? S2 : S3;        // S2
            current_state[3]: next_state = data ? FOUND : IDLE;   // S3
            current_state[4]: next_state = FOUND;                 // FOUND
        endcase
    end

    // Output logic - direct from FOUND state bit
    always @(*) begin
        start_shifting = current_state[4];
    end

endmodule