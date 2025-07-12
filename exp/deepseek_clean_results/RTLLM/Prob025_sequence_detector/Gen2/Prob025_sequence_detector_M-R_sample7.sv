module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// State encoding
localparam [2:0] IDLE   = 3'b000;
localparam [2:0] S1     = 3'b001;
localparam [2:0] S10    = 3'b010;
localparam [2:0] S100   = 3'b011;
localparam [2:0] S1001  = 3'b100;

reg [2:0] current_state, next_state;

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = data_in ? S1 : IDLE;
        S1:     next_state = data_in ? S1 : S10;
        S10:    next_state = data_in ? S1 : S100;
        S100:   next_state = data_in ? S1001 : IDLE;
        S1001:  next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic (Moore style)
assign sequence_detected = (current_state == S1001);

endmodule