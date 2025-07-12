module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Gray-coded state encoding for reduced switching power
localparam [2:0] IDLE   = 3'b000;
localparam [2:0] S1     = 3'b001;
localparam [2:0] S10    = 3'b011;
localparam [2:0] S100   = 3'b010;
localparam [2:0] S1001  = 3'b110;

reg [2:0] current_state, next_state;

// State register with async reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Registered output for better timing
        sequence_detected <= (next_state == S1001);
    end
end

// Optimized next state logic
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

endmodule