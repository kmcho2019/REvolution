module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// One-hot state encoding
localparam IDLE  = 3'b000;
localparam S1    = 3'b001;
localparam S10   = 3'b010;
localparam S100  = 3'b100;
localparam DETECT = 3'b101;  // Detection state

reg [2:0] current_state;

// State transition logic using continuous assignments
wire [2:0] next_state;
assign next_state = 
    (!reset_n) ? IDLE :
    (current_state == IDLE)  ? (data_in ? S1 : IDLE) :
    (current_state == S1)    ? (data_in ? S1 : S10) :
    (current_state == S10)   ? (data_in ? S1 : S100) :
    (current_state == S100)  ? (data_in ? DETECT : IDLE) :
    (current_state == DETECT) ? IDLE : IDLE;

// State register
always @(posedge clk) begin
    current_state <= next_state;
end

// Output logic - Moore style (only depends on state)
assign sequence_detected = (current_state == DETECT);

endmodule