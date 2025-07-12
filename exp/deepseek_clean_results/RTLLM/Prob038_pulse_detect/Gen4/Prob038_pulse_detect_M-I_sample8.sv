module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding - binary instead of enum for better compatibility
localparam [1:0] 
    IDLE         = 2'b00,
    GOT_0        = 2'b01,
    GOT_01       = 2'b10,
    PULSE_DETECT = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        data_out <= (next_state == PULSE_DETECT);
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = data_in ? IDLE : GOT_0;
        GOT_0: next_state = data_in ? GOT_01 : GOT_0;
        GOT_01: next_state = data_in ? IDLE : PULSE_DETECT;
        PULSE_DETECT: next_state = data_in ? IDLE : GOT_0;
        default: next_state = IDLE;
    endcase
end

endmodule