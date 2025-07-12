module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using localparam for synthesis compatibility
    localparam IDLE      = 2'b00; // waiting for 0 (start state)
    localparam WAIT_HIGH = 2'b01; // detected rising edge, waiting for stable high
    localparam WAIT_LOW  = 2'b10; // detected high, waiting for falling edge back to 0

    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE;
            end

            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else
                    next_state = IDLE;
            end

            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = WAIT_LOW;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state and output update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Assert data_out for one clock cycle when finishing a pulse:
            // Pulse ends when current state is WAIT_LOW and data_in goes low (transition back to IDLE)
            if (state == WAIT_LOW && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule