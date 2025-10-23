module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the sequence detection
enum logic [1:0] {
    IDLE = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10,
    S3 = 2'b11
} state;

// Update the state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: 
                if (data_in) state <= S1;
                else state <= IDLE;
            S1: 
                if (!data_in) state <= S2;
                else state <= IDLE;
            S2: 
                if (!data_in) state <= S3;
                else state <= IDLE;
            S3: 
                if (data_in) state <= IDLE;
                else state <= IDLE;
        endcase
    end
end

// Assign the sequence_detected output
assign sequence_detected = (state == S3);

endmodule