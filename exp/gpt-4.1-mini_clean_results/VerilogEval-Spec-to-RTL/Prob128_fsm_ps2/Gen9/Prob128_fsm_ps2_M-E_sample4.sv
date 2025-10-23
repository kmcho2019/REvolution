module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted only when transitioning from BYTE3 to IDLE
            done <= (state == BYTE3) && (next_state == IDLE);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule