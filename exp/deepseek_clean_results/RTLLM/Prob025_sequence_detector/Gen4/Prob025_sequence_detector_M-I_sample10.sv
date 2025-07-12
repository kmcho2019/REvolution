module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot state encoding
localparam [4:0] IDLE   = 5'b00001;
localparam [4:0] S1     = 5'b00010;
localparam [4:0] S10    = 5'b00100;
localparam [4:0] S100   = 5'b01000;
localparam [4:0] S1001  = 5'b10000;

reg [4:0] current_state, next_state;
reg data_in_prev;

// Clock gating condition
wire state_change = (data_in != data_in_prev);

// State register with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_in_prev <= 1'b0;
    end else begin
        data_in_prev <= data_in;
        if (state_change) begin
            current_state <= next_state;
        end
    end
end

// Next state logic (simplified with one-hot)
always @(*) begin
    next_state = current_state; // Default hold state
    
    case (1'b1) // synthesis parallel_case
        current_state[0]: // IDLE
            next_state = data_in ? S1 : IDLE;
        current_state[1]: // S1
            next_state = data_in ? S1 : S10;
        current_state[2]: // S10
            next_state = data_in ? S1 : S100;
        current_state[3]: // S100
            next_state = data_in ? S1001 : IDLE;
        current_state[4]: // S1001
            next_state = data_in ? S1 : IDLE;
    endcase
end

// Registered output for better timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sequence_detected <= 1'b0;
    end else begin
        sequence_detected <= (next_state == S1001);
    end
end

endmodule