module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;

    reg state, next_state;
    reg data_in_d;  // Delayed data_in for edge detection

    // Register delayed input for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                next_state = data_in ? HIGH : IDLE;
            HIGH:
                next_state = data_in ? HIGH : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic: combinational detection of falling edge from HIGH state
    always @(*) begin
        // Default no pulse
        data_out = 1'b0;
        // Pulse detected when previously HIGH state and data_in falls from 1 to 0
        if ((state == HIGH) && (data_in == 1'b0) && (data_in_d == 1'b1))
            data_out = 1'b1;
    end

endmodule