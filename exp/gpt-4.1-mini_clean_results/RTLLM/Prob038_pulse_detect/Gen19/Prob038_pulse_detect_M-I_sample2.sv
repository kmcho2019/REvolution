module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;

    reg state, next_state;
    reg prev_data_in;

    // Sample data_in only when it changes to reduce toggling (conditional sampling)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_data_in <= 1'b0;
        end else if (data_in != prev_data_in) begin
            prev_data_in <= data_in;
        end
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
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

    // Output logic: detect falling edge of data_in after HIGH state and register data_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            // pulse detected: data_in falls from 1 to 0 and previous state HIGH
            if ((state == HIGH) && (data_in == 1'b0) && (prev_data_in == 1'b1))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule