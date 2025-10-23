module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
enum {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

// Registers to store the message bytes
reg [23:0] out_bytes_reg;

// Output signals
reg done_reg;

always @(*) begin
    // Default values for output signals
    done_reg = 0;
    next_state = state;

    case (state)
        IDLE: begin
            if (~reset) begin
                next_state = IDLE;
            end else if (in[3]) begin
                out_bytes_reg[23:16] = in;
                next_state = BYTE1;
            end
        end

        BYTE1: begin
            out_bytes_reg[15:8] = in;
            next_state = BYTE2;
        end

        BYTE2: begin
            out_bytes_reg[7:0] = in;
            next_state = BYTE3;
        end

        BYTE3: begin
            done_reg = 1;
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        state <= next_state;
        out_bytes_reg <= out_bytes_reg;
        done_reg <= done_reg;
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule