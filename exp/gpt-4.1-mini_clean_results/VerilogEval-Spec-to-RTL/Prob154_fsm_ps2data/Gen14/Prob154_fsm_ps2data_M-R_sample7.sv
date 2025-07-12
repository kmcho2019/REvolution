module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

    // States
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        CAPTURE = 2'b01
    } state_t;

    state_t state, next_state;
    reg [1:0] byte_count, next_byte_count;
    reg [23:0] bytes_reg;

    // State and byte count registers
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            byte_count <= 2'd0;
            bytes_reg  <= 24'd0;
        end else begin
            state      <= next_state;
            byte_count <= next_byte_count;
            bytes_reg  <= (state == CAPTURE) ? {bytes_reg[15:0], in} : bytes_reg;
        end
    end

    // Next state and byte count logic
    always @(*) begin
        next_state = state;
        next_byte_count = byte_count;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = CAPTURE;
                    next_byte_count = 2'd1;
                end
            end
            CAPTURE: begin
                if (byte_count == 2'd3) begin
                    next_state = IDLE;
                    next_byte_count = 2'd0;
                end else begin
                    next_byte_count = byte_count + 1;
                end
            end
        endcase
    end

    // Done signal asserted combinationally: when state=CAPTURE and byte_count=3
    assign done = (state == CAPTURE) && (byte_count == 2'd3);

    // out_bytes valid when done is high, otherwise don't-care
    assign out_bytes = done ? bytes_reg : 24'bx;

endmodule