module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
localparam IDLE          = 2'b00;
localparam GOT_0         = 2'b01;
localparam GOT_01        = 2'b10;
localparam PULSE_DETECTED = 2'b11;

reg [1:0] state, next_state;

// State transition logic
always @(*) begin
    case (state)
        IDLE:          next_state = (data_in == 0) ? GOT_0 : IDLE;
        GOT_0:         next_state = (data_in == 1) ? GOT_01 : GOT_0;
        GOT_01:        next_state = (data_in == 0) ? PULSE_DETECTED : IDLE;
        PULSE_DETECTED: next_state = IDLE;
        default:       next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Output logic (combinational)
assign data_out = (state == GOT_01) && (data_in == 0);

endmodule