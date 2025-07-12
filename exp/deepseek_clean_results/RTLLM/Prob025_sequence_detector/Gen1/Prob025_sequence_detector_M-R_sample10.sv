module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT1   = 2'b01;
localparam [1:0] GOT10  = 2'b10;
localparam [1:0] GOT100 = 2'b11;

reg [1:0] current_state, next_state;

// State transition and output logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Mealy output: depends on current state AND input
        sequence_detected <= (current_state == GOT100) && data_in;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = data_in ? GOT1 : IDLE;
        GOT1:   next_state = data_in ? GOT1 : GOT10;
        GOT10:  next_state = data_in ? GOT1 : GOT100;
        GOT100: next_state = data_in ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule