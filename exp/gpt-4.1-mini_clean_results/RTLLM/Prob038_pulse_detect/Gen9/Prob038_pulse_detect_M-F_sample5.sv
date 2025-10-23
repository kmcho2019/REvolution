module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam WAIT_LOW       = 2'd0; // waiting for data_in=0 (start)
    localparam WAIT_HIGH      = 2'd1; // detected 0, waiting for 1
    localparam WAIT_LOW2      = 2'd2; // detected 1, waiting for 0 (pulse end)
    localparam PULSE_DETECTED = 2'd3; // pulse detected, output=1 for one cycle

    reg [1:0] state, next_state;

    // Sequential: state update and data_out generation (Moore output based on current state)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= WAIT_LOW;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is asserted only in PULSE_DETECTED state
            data_out <= (state == PULSE_DETECTED);
        end
    end

    // Combinational: next state logic (simplified)
    always @(*) begin
        case (state)
            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = WAIT_LOW;
            end

            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW2;
                else
                    next_state = WAIT_HIGH;
            end

            WAIT_LOW2: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else
                    next_state = WAIT_LOW2;
            end

            PULSE_DETECTED: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = WAIT_LOW;
            end

            default: next_state = WAIT_LOW;
        endcase
    end

endmodule