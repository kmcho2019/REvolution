module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// Binary state encoding with Gray-like ordering
localparam [2:0] IDLE   = 3'b000;
localparam [2:0] S1     = 3'b001;
localparam [2:0] S10    = 3'b011;
localparam [2:0] S100   = 3'b010;
localparam [2:0] S1001  = 3'b110;

reg [2:0] current_state;

// State register with async reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic using continuous assignments
wire [2:0] next_state;
assign next_state = 
    (current_state == IDLE)  ? (data_in ? S1     : IDLE) :
    (current_state == S1)    ? (data_in ? S1     : S10)  :
    (current_state == S10)   ? (data_in ? S1     : S100) :
    (current_state == S100)  ? (data_in ? S1001  : IDLE) :
    (current_state == S1001) ? (data_in ? S1     : IDLE) :
                               IDLE; // Default case

// Output logic - direct state comparison
assign sequence_detected = (current_state == S1001);

endmodule