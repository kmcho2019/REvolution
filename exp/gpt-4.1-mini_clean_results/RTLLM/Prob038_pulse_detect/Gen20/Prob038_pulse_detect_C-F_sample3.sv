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
    reg data_in_d;  // delayed version of data_in for edge detection

    // Sample data_in to detect edges
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

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = HIGH;
            end
            default: next_state = IDLE;
        endcase
    end

    // Registered output logic: data_out asserted 1 cycle when falling edge of data_in after HIGH state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 1'b0;
        else
            // Detect falling edge: previous data_in_d == 1 and current data_in == 0, and was in HIGH state
            data_out <= (state == HIGH) && (data_in == 1'b0) && (data_in_d == 1'b1);
    end

endmodule