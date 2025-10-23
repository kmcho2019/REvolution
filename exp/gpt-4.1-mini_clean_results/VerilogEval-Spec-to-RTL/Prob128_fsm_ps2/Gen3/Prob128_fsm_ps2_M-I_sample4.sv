module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Binary encoding of states (2 bits)
    localparam WAIT_FOR_START = 2'b00;
    localparam BYTE2          = 2'b01;
    localparam BYTE3          = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only for one cycle immediately after the third byte received
            done <= (state == BYTE3);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WAIT_FOR_START: begin
                if (in[3])
                    next_state = BYTE2;
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