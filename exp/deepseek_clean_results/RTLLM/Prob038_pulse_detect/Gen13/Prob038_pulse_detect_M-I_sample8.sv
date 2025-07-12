module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Binary state encoding with explicit pulse detect state
localparam IDLE         = 2'b00;
localparam GOT_LOW      = 2'b01;
localparam GOT_LOW_HIGH = 2'b10;
localparam PULSE_DETECT = 2'b11;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE:         next_state = data_in ? IDLE : GOT_LOW;
        GOT_LOW:      next_state = data_in ? GOT_LOW_HIGH : GOT_LOW;
        GOT_LOW_HIGH: next_state = data_in ? GOT_LOW_HIGH : PULSE_DETECT;
        PULSE_DETECT: next_state = data_in ? IDLE : GOT_LOW;
        default:      next_state = IDLE;
    endcase
end

// State register and output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        // Output is high only in PULSE_DETECT state
        data_out <= (next_state == PULSE_DETECT);
    end
end

endmodule