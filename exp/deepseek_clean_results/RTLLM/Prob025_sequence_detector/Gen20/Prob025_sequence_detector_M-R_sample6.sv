module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam IDLE = 2'b00;
localparam S1   = 2'b01;  // Received '1'
localparam S2   = 2'b10;  // Received '10'
localparam S3   = 2'b11;  // Received '100'

reg [1:0] current_state, next_state;

// State transition logic (combinational)
assign next_state = (!reset_n) ? IDLE :
                   (current_state == IDLE) ? (data_in ? S1 : IDLE) :
                   (current_state == S1)   ? (data_in ? S1 : S2) :
                   (current_state == S2)   ? (data_in ? S3 : IDLE) :
                   (current_state == S3)   ? (data_in ? S1 : S2) : IDLE;

// Output logic (combinational)
wire sequence_detected_next = (current_state == S3) && data_in;

// State register (sequential)
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        sequence_detected <= sequence_detected_next;
    end
end

endmodule