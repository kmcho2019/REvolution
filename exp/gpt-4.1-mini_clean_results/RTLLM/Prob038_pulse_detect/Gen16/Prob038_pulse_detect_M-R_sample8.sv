module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // One-hot state encoding
    localparam IDLE         = 3'b001;
    localparam RISE_DETECTED= 3'b010;
    localparam PULSE_DONE   = 3'b100;

    reg [2:0] state, next_state;
    reg       data_in_d;  // delayed data_in for edge detection

    // Edge detection signals using assign
    wire rising_edge  = (~data_in_d) & data_in;
    wire falling_edge = data_in_d & (~data_in);

    // data_out is asserted at the falling edge after rising edge detected (pulse end)
    assign data_out = (state == RISE_DETECTED) && falling_edge;

    // Register data_in_d for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (rising_edge)
                    next_state = RISE_DETECTED;
                else
                    next_state = IDLE;
            end

            RISE_DETECTED: begin
                if (falling_edge)
                    next_state = IDLE; // pulse completed, go back to IDLE
                else
                    next_state = RISE_DETECTED;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule