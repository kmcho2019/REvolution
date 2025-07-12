module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE1,
        BYTE2
    } state_t;

    // State registers
    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2;
    reg [7:0] next_byte1, next_byte2;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            byte1 <= next_byte1;
            byte2 <= next_byte2;
            
            // Output logic
            if (next_state == IDLE && state == BYTE2) begin
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        next_byte1 = byte1;
        next_byte2 = byte2;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    next_byte1 = in;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                next_byte2 = in;
            end
            BYTE2: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule