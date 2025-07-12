module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // One-hot state encoding
    localparam WAIT_FOR_START = 3'b001;
    localparam BYTE2          = 3'b010;
    localparam BYTE3          = 3'b100;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done only one cycle when in BYTE3 state completes
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