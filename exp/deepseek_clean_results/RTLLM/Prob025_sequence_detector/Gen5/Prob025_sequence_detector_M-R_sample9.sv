module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot state encoding
localparam IDLE  = 4'b0001;
localparam S1    = 4'b0010;
localparam S10   = 4'b0100;
localparam S100  = 4'b1000;
// S1001 state not needed as we can detect and return to IDLE

reg [3:0] current_state, next_state;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Registered output - only set when we detect 1001 in S100 state
        sequence_detected <= (current_state == S100) && data_in;
    end
end

// Next state logic using one-hot advantages
always @(*) begin
    next_state = IDLE;  // Default case
    
    if (current_state[0]) begin       // IDLE
        next_state = data_in ? S1 : IDLE;
    end
    else if (current_state[1]) begin  // S1
        next_state = data_in ? S1 : S10;
    end
    else if (current_state[2]) begin  // S10
        next_state = data_in ? S1 : S100;
    end
    else if (current_state[3]) begin  // S100
        next_state = data_in ? IDLE : IDLE;  // If we get 1, detect sequence
    end
end

endmodule