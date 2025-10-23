module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    state_t state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;

    // Combinational logic for next state and outputs
    always @(*) begin
        next_state     = state;
        next_out_bytes = out_bytes;
        next_done      = 1'b0;

        case(state)
            IDLE: begin
                if(in[3]) begin
                    // Found start byte
                    next_out_bytes = {in, 16'b0};
                    next_state     = BYTE1;
                end
            end

            BYTE1: begin
                // Shift previously stored bytes left by 8 bits, append new byte
                next_out_bytes = {out_bytes[15:0], in};
                next_state     = BYTE2;
            end

            BYTE2: begin
                // Shift and append third byte, assert done next cycle
                next_out_bytes = {out_bytes[15:0], in};
                next_done      = 1'b1;
                next_state     = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential update
    always @(posedge clk) begin
        if(reset) begin
            state     <= IDLE;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state     <= next_state;
            out_bytes <= next_out_bytes;
            done      <= next_done;
        end
    end

endmodule