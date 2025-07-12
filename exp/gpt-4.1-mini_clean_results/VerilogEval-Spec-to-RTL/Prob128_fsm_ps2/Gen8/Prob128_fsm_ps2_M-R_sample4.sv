module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

    // Binary encoded FSM states
    localparam WAIT_FOR_START = 2'b00;
    localparam BYTE2          = 2'b01;
    localparam BYTE3          = 2'b10;

    reg [1:0] state, next_state;
    reg done_pulse;

    // Sequential logic: state and done signal updates
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
            done_pulse <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_pulse;
            done_pulse <= (state == BYTE3 && next_state == WAIT_FOR_START);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = WAIT_FOR_START;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = WAIT_FOR_START;
            end
            default: next_state = WAIT_FOR_START;
        endcase
    end

endmodule