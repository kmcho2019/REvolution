module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// State encoding
localparam [2:0] IDLE = 3'b000;
localparam [2:0] S1   = 3'b001;
localparam [2:0] S2   = 3'b010;
localparam [2:0] S3   = 3'b011;
localparam [2:0] S4   = 3'b100;

reg [2:0] current_state, next_state;

// State transition logic (combinational)
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S4 : S2;
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// State register (sequential)
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule