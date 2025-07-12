module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

reg [2:0] state; // State register with 3 bits to represent 5 states
localparam IDLE = 3'b000;
localparam S1   = 3'b001;
localparam S2   = 3'b010;
localparam S3   = 3'b011;
localparam S4   = 3'b100;

reg [2:0] next_state; // Next state register

// Combinational logic for next state
always @(*) begin
    case (state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? IDLE : S2;
        S2:   next_state = data_in ? IDLE : S3;
        S3:   next_state = data_in ? S4 : IDLE;
        S4:   next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic for current state update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign sequence_detected = (state == S4);

endmodule