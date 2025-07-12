module sequence_detector(
    input        clk,       // Clock signal
    input        reset_n,   // Reset signal (active low)
    input        data_in,   // 1-bit binary input signal
    output       sequence_detected  // 1-bit output signal
);

// Define the states
parameter IDLE = 4'b0000;
parameter S1    = 4'b0001;
parameter S2    = 4'b0010;
parameter S3    = 4'b0011;
parameter S4    = 4'b0100;

reg [3:0] current_state;
reg [3:0] next_state;

// State machine
always @(*) begin
    case (current_state)
        IDLE: 
            if (data_in == 1'b1) 
                next_state = S1;
            else 
                next_state = IDLE;
        
        S1: 
            if (data_in == 1'b0) 
                next_state = S2;
            else 
                next_state = S1;
        
        S2: 
            if (data_in == 1'b0) 
                next_state = S2;
            else 
                next_state = S3;
        
        S3: 
            if (data_in == 1'b1) 
                next_state = S4;
            else 
                next_state = IDLE;
        
        S4: 
            next_state = IDLE;  // Sequence detected, return to IDLE
        default: 
            next_state = IDLE;
    endcase
end

// Assign output
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// Update state on clock edge
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule