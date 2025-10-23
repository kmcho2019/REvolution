module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// One-hot state encoding
parameter [3:0] IDLE   = 4'b0001;
parameter [3:0] GOT1   = 4'b0010;
parameter [3:0] GOT10  = 4'b0100;
parameter [3:0] GOT100 = 4'b1000;

reg [3:0] current_state, next_state;
reg sequence_detected_comb;

// Sequential state transition
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        sequence_detected <= sequence_detected_comb;
    end
end

// Combinational next state and output logic
always @(*) begin
    next_state = IDLE;
    sequence_detected_comb = 1'b0;
    
    case (1'b1) // synthesis parallel_case
        current_state[0]: // IDLE
            next_state = data_in ? GOT1 : IDLE;
            
        current_state[1]: // GOT1
            next_state = data_in ? GOT1 : GOT10;
            
        current_state[2]: // GOT10
            next_state = data_in ? GOT1 : GOT100;
            
        current_state[3]: begin // GOT100
            sequence_detected_comb = data_in;
            next_state = data_in ? GOT1 : IDLE;
        end
    endcase
end

endmodule