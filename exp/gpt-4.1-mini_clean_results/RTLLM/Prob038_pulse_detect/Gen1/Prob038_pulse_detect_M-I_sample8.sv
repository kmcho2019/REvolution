module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using parameters for Verilog-2001 compatibility
    parameter IDLE       = 2'd0; // Waiting for first '0' in pulse
    parameter WAIT_HIGH  = 2'd1; // Got '0', waiting for '1'
    parameter WAIT_LOW   = 2'd2; // Got '1', waiting for '0' (pulse completion)

    reg [1:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE;
            end
            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE; // Defensive, not strictly needed as input is 1-bit
            end
            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // Pulse complete, restart detection
                else if (data_in == 1'b1)
                    next_state = WAIT_LOW; // wait for final zero
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: update state and generate output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out asserted for one clock cycle at pulse completion (transition into IDLE from WAIT_LOW on data_in=0)
            if (state == WAIT_LOW && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule