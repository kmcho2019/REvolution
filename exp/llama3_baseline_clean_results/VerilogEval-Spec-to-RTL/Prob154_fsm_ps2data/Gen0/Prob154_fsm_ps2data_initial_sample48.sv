module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // Enum for states
    enum logic [1:0] {
        IDLE,
        BYTE1,
        BYTE2,
        DONE
    } state, next_state;

    // 24-bit register to store the message
    logic [23:0] msg;

    // Counter to keep track of the current byte position
    logic [1:0] byte_pos;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg <= 24'b0;
            byte_pos <= 2'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        msg[7:0] <= in;
                        byte_pos <= 2'b1;
                    end
                end
                BYTE1: begin
                    msg[15:8] <= in;
                    byte_pos <= 2'b2;
                end
                BYTE2: begin
                    msg[23:16] <= in;
                    byte_pos <= 2'b0;
                end
                DONE: begin
                    byte_pos <= 2'b0;
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        case (state)
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
                next_state = IDLE;
            end
        endcase
    end

    assign out_bytes = (state == DONE) ? msg : 24'b0;
    assign done = (state == DONE);

endmodule