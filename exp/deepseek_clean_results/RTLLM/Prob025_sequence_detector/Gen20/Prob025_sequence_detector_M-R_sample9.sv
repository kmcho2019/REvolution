module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states
localparam [4:0] IDLE = 5'b00001;
localparam [4:0] S1   = 5'b00010;  // '1' received
localparam [4:0] S2   = 5'b00100;  // '10' received
localparam [4:0] S3   = 5'b01000;  // '100' received
localparam [4:0] S4   = 5'b10000;  // '1001' received (detection)

reg [4:0] current_state, next_state;

// State transition logic (continuous assignment)
assign next_state = (!rst_n) ? IDLE :
                   (current_state == IDLE) ? (data_in ? S1 : IDLE) :
                   (current_state == S1)   ? (data_in ? S1 : S2) :
                   (current_state == S2)   ? (data_in ? S3 : IDLE) :
                   (current_state == S3)   ? (data_in ? S4 : S2) :
                   (current_state == S4)   ? (data_in ? S1 : S2) :
                   IDLE;

// Sequential state update
always @(posedge clk) begin
    current_state <= next_state;
end

// Output logic (registered)
always @(posedge clk) begin
    sequence_detected <= (next_state == S4);
end

endmodule