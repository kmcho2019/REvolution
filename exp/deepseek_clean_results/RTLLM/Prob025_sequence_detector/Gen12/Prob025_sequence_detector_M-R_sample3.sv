module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam IDLE = 3'b000;
localparam S1   = 3'b001;  // Received '1'
localparam S2   = 3'b010;  // Received '10'
localparam S3   = 3'b011;  // Received '100'
localparam S4   = 3'b100;  // Received '1001' (output high)

reg [2:0] current_state, next_state;

// State transition logic (combinational)
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   next_state = data_in ? S4 : IDLE;
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// State register and output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        sequence_detected <= (next_state == S4);
    end
end

endmodule