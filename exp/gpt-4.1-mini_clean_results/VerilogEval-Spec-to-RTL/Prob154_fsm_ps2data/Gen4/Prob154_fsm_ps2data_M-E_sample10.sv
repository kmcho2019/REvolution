module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        DONE  = 2'b11
    } state_t;

    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state, next_state;

    // Next state logic and data capture
    always @(*) begin
        next_state = state;
        done = 1'b0;

        case(state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and datapath update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            byte3     <= 8'b0;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (in[3]) byte1 <= in;
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                end
                DONE: begin
                    out_bytes <= {byte1, byte2, byte3};
                end
            endcase
        end
    end

endmodule