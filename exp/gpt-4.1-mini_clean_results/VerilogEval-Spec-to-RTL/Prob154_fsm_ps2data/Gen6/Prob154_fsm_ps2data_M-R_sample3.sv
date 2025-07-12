module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] byte1, byte2;

    // Next state and outputs logic (combinational)
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
                done = 1'b1;
            end
        endcase
    end

    // Sequential logic for state and data registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done; // From combinational logic
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    out_bytes <= {byte1, byte2, in};
                end
            endcase
        end
    end

endmodule