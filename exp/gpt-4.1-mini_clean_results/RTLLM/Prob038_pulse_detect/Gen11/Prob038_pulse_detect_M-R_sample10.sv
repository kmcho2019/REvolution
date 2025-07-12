module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot encoded states
    localparam IDLE      = 3'b001;
    localparam HIGH      = 3'b010;
    localparam PULSE_END = 3'b100;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (~data_in)
                    next_state = PULSE_END;
                else
                    next_state = HIGH;
            end
            PULSE_END: begin
                // Output asserted this cycle, next go back to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: asserted only in PULSE_END state
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_out <= 1'b0;
        else if (next_state == PULSE_END)
            data_out <= 1'b1;
        else
            data_out <= 1'b0;
    end

endmodule