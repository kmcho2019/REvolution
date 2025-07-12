module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam HIGH    = 3'b010;
    localparam FALLING = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic and output generation combined for simpler logic
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        data_out = 1'b0;

        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (~data_in) begin
                    next_state = FALLING;
                    data_out = 1'b1;  // Output pulse at falling edge detection
                end else begin
                    next_state = HIGH;
                end
            end
            FALLING: begin
                // After output pulse, go back to IDLE for new detection
                next_state = IDLE;
                data_out = 1'b0;
            end
            default: begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        endcase
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule