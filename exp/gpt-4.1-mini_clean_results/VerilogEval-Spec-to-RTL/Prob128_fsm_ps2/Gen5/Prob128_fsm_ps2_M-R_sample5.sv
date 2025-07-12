module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Binary state encoding
    localparam WAIT_FOR_START = 2'b00;
    localparam BYTE2          = 2'b01;
    localparam BYTE3          = 2'b10;

    reg [1:0] state, next_state;
    reg done_next;

    // Next state logic and done combinational output logic
    always @(*) begin
        next_state = state;
        done_next = 1'b0;
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
                done_next = 1'b1; // signal done immediately when leaving BYTE3
            end
            default: begin
                next_state = WAIT_FOR_START;
            end
        endcase
    end

    // State register and done output register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_next;
        end
    end

endmodule