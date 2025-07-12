module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Binary state encoding
localparam IDLE = 2'b00;
localparam S1   = 2'b01;
localparam S10  = 2'b10;
localparam S100 = 2'b11;

reg [1:0] current_state, next_state;

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Output is high when we detect '1' in S100 state
        sequence_detected <= (current_state == S100) && data_in;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S10;
        S10:  next_state = data_in ? S1 : S100;
        S100: next_state = data_in ? IDLE : IDLE; // Sequence detected if data_in=1
        default: next_state = IDLE;
    endcase
end

endmodule