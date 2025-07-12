module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
localparam IDLE          = 2'b00;
localparam GOT_0         = 2'b01;
localparam GOT_1         = 2'b10;
localparam PULSE_DETECTED = 2'b11;

reg [1:0] state, next_state;
reg data_out_reg;

// State transition logic
always @(*) begin
    case (state)
        IDLE:          next_state = data_in ? IDLE : GOT_0;
        GOT_0:        next_state = data_in ? GOT_1 : GOT_0;
        GOT_1:         next_state = data_in ? IDLE : PULSE_DETECTED;
        PULSE_DETECTED: next_state = IDLE;
        default:       next_state = IDLE;
    endcase
end

// State register and output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out_reg <= 1'b0;
    end
    else begin
        state <= next_state;
        data_out_reg <= (next_state == PULSE_DETECTED);
    end
end

// Continuous output assignment
assign data_out = data_out_reg;

endmodule