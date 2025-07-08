module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        done = 1'b0;
        case(state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                // After third byte received, signal done, then back to IDLE
                next_state = IDLE;
                done = 1'b1;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule