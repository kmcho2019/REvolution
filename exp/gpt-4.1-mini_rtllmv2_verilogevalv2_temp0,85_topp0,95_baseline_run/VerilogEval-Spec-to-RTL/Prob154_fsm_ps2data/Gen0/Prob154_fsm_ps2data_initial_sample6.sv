module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg    done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers to hold message bytes
    reg [7:0] byte1, byte2, byte3;

    // Next state logic and output logic
    always @(*) begin
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                if (in[3]) // bit 3 set: start message
                    next_state = BYTE1;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = IDLE;
                done = 1'b1; // message complete after third byte
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done; // done assigned in combinational always above

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        // clear byte2, byte3 since starting new message
                        byte2 <= 8'b0;
                        byte3 <= 8'b0;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                    // output message is valid only here, done is asserted here
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

endmodule