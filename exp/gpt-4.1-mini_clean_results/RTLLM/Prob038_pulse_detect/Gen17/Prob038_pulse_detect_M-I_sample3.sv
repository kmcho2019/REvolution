module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding: only one bit needed for two states
    localparam IDLE          = 1'b0;
    localparam HIGH_DETECTED = 1'b1;

    reg state, next_state;
    reg data_in_d;  // delayed data_in for edge detection

    // Synchronous reset and clock enable for data_in_d update
    wire data_in_change = (data_in != data_in_d);

    always @(posedge clk) begin
        if (!rst_n) begin
            data_in_d <= 1'b0;
        end else if (data_in_change) begin
            data_in_d <= data_in;
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    wire rising_edge  = (~data_in_d) & data_in;
    wire falling_edge = data_in_d & (~data_in);

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
                    data_out = 1'b1;  // Pulse complete at falling edge
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule