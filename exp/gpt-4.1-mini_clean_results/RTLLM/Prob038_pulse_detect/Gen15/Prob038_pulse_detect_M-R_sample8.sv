module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam WAIT_HIGH = 2'd1;
    localparam WAIT_LOW  = 2'd2;
    localparam PULSE_END = 2'd3;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;  // data_in went from 0 to 1: wait for 0
                else
                    next_state = IDLE;
            end
            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END; // detected 0 after 1 => pulse end
                else
                    next_state = WAIT_LOW;
            end
            PULSE_END: begin
                next_state = IDLE;        // output pulse, then reset
            end
            default: begin // Covers WAIT_HIGH or unexpected states
                next_state = IDLE;
            end
        endcase
    end

    // State and output registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output 1 only for one cycle in PULSE_END state
            data_out <= (next_state == PULSE_END);
        end
    end

endmodule