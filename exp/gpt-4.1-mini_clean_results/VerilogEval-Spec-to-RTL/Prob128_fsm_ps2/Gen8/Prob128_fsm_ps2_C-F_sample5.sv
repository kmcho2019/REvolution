module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Binary encoded FSM states
    localparam WAIT_FOR_START = 2'b00;
    localparam BYTE2          = 2'b01;
    localparam BYTE3          = 2'b10;

    reg [1:0] state, next_state;

    // Sequential block: state and done register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted for one cycle right after third byte received
            done <= (state == BYTE3);
        end
    end

    // Combinational block: next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = WAIT_FOR_START;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = WAIT_FOR_START;
            default: next_state = WAIT_FOR_START;
        endcase
    end

endmodule