module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define the states of the FSM
enum logic [1:0] {
    idle,
    byte1,
    byte2,
    done_state
} state, next_state;

// Define the registers to store the bytes of the message
reg [7:0] byte1_reg, byte2_reg, byte3_reg;

// Define the current state and next state logic
always_comb begin
    case (state)
        idle: begin
            if (in[3] == 1) begin
                next_state = byte1;
            end else begin
                next_state = idle;
            end
        end
        byte1: begin
            next_state = byte2;
        end
        byte2: begin
            next_state = done_state;
        end
        done_state: begin
            next_state = idle;
        end
    endcase
end

// Define the sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= idle;
        done <= 0;
        out_bytes <= 0;
        byte1_reg <= 0;
        byte2_reg <= 0;
        byte3_reg <= 0;
    end else begin
        state <= next_state;
        case (state)
            idle: begin
                byte1_reg <= 0;
                byte2_reg <= 0;
                byte3_reg <= 0;
                if (in[3] == 1) begin
                    byte1_reg <= in;
                end
            end
            byte1: begin
                byte2_reg <= in;
            end
            byte2: begin
                byte3_reg <= in;
            end
            done_state: begin
                done <= 1;
                out_bytes <= {byte1_reg, byte2_reg, byte3_reg};
            end
        endcase
        if (next_state != done_state) begin
            done <= 0;
        end
    end
end

endmodule