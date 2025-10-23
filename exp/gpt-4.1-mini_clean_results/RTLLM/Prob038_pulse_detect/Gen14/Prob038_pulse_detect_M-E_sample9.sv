module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding (2 bits)
    localparam IDLE      = 2'd0; // Waiting for data_in=1
    localparam HIGH      = 2'd1; // data_in=1 detected
    localparam PULSE_END = 2'd2; // data_in=0 after HIGH detected (pulse end)

    reg [1:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only in PULSE_END state for one clock cycle
            data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (!data_in)
                    next_state = PULSE_END;
                else
                    next_state = HIGH;
            end

            PULSE_END: begin
                // After outputting pulse, go back to IDLE regardless of data_in
                next_state = data_in ? HIGH : IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule