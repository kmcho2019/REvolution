module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum reg [1:0] {IDLE=2'd0, HIGH=2'd1, PULSE_END=2'd2} state_t;
    state_t state, next_state;

    // State and output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;
            // Output asserted only in PULSE_END state, one cycle pulse
            data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:       next_state = data_in ? HIGH : IDLE;
            HIGH:       next_state = (data_in == 1'b0) ? PULSE_END : HIGH;
            PULSE_END:  next_state = data_in ? HIGH : IDLE;
            default:    next_state = IDLE;
        endcase
    end

endmodule