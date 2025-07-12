module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding
    localparam [1:0] 
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10;

    // State registers
    reg [1:0] state, next_state;

    // Sequential state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in[3] ? BYTE2 : IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic - done is asserted when leaving BYTE3 state
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= (state == BYTE3);
        end
    end

endmodule