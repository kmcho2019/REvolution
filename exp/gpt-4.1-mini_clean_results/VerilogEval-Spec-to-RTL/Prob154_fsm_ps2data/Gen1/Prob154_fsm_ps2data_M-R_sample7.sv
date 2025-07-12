module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);
    // States for the FSM
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'd0,
        BYTE_2         = 2'd1,
        BYTE_3         = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    // Shift register to hold bytes received
    reg [23:0] byte_shift;

    // Counter to track how many bytes of the message received (1..3)
    reg [1:0] byte_count, next_byte_count;

    // Sequential block: state and data registers updated on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state      <= WAIT_FOR_START;
            byte_shift <= 24'd0;
            byte_count <= 2'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            state      <= next_state;
            byte_count <= next_byte_count;
            done       <= 1'b0;  // default no done unless set below

            // Shift in data when in collecting states
            if (state != WAIT_FOR_START) begin
                // Shift left by 8 bits and insert new byte at LSB
                byte_shift <= {byte_shift[15:0], in};
            end else begin
                // When waiting for start, only load when start detected
                if (in[3]) begin
                    byte_shift <= {in, 16'd0};
                end
            end

            // Output the message and assert done in the cycle immediately after 3rd byte received
            if (state == BYTE_3) begin
                out_bytes <= byte_shift;
                done      <= 1'b1;
            end
        end
    end

    // Combinational next state and byte_count logic
    always @(*) begin
        next_state = state;
        next_byte_count = byte_count;

        case(state)
            WAIT_FOR_START: begin
                if (in[3]) begin
                    next_state = BYTE_2;
                    next_byte_count = 2'd1; // first byte captured
                end else begin
                    next_state = WAIT_FOR_START;
                    next_byte_count = 2'd0;
                end
            end
            BYTE_2: begin
                next_state = BYTE_3;
                next_byte_count = 2'd2;
            end
            BYTE_3: begin
                next_state = WAIT_FOR_START;
                next_byte_count = 2'd3; // third byte done here (can also reset to 0 next cycle)
            end
            default: begin
                next_state = WAIT_FOR_START;
                next_byte_count = 2'd0;
            end
        endcase
    end
endmodule