module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Enum for states
enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

// Internal registers
logic [23:0] out_bytes_reg;
logic done_reg;

// Combinational logic
always_comb begin
    // Default values
    next_state = state;
    done_reg = 1'b0;

    case (state)
        IDLE: begin
            if (reset) begin
                next_state = IDLE;
            end else if (in[3] == 1'b1) begin
                out_bytes_reg[7:0] = in;
                next_state = BYTE1;
            end
        end

        BYTE1: begin
            out_bytes_reg[15:8] = in;
            next_state = BYTE2;
        end

        BYTE2: begin
            out_bytes_reg[23:16] = in;
            next_state = BYTE3;
        end

        BYTE3: begin
            done_reg = 1'b1;
            next_state = IDLE;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'd0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        out_bytes <= out_bytes_reg;
        done <= done_reg;
    end
end

endmodule