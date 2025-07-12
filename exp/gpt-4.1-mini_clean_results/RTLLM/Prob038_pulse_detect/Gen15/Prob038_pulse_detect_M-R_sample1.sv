module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE         = 2'b00;
    localparam HIGH_DETECTED = 2'b01;

    reg [1:0] state, next_state;
    reg       data_in_d;  // delayed data_in for edge detection

    // Edge detection signals
    wire rising_edge  = (~data_in_d) & data_in;
    wire falling_edge = data_in_d & (~data_in);

    // Register data_in_d to detect edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and data_out combinational logic
    always @(*) begin
        next_state = state;
        data_out   = 1'b0;

        case(state)
            IDLE: begin
                if (rising_edge)
                    next_state = HIGH_DETECTED;
            end

            HIGH_DETECTED: begin
                if (falling_edge) begin
                    data_out = 1'b1;  // Pulse completed at falling edge
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule