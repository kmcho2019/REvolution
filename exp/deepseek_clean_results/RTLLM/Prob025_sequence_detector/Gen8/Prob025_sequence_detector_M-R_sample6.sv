module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// Binary state encoding
localparam [1:0] IDLE = 2'b00;
localparam [1:0] S1   = 2'b01;
localparam [1:0] S10  = 2'b10;
localparam [1:0] S100 = 2'b11;

reg [1:0] current_state, next_state;

// Output is combinational - detects when in S100 and input is 1
assign sequence_detected = (current_state == S100) && data_in;

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic using case statement
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S10;
        S10:  next_state = data_in ? S1 : S100;
        S100: next_state = data_in ? IDLE : IDLE; // On 1, detect and reset
        default: next_state = IDLE;
    endcase
end

endmodule