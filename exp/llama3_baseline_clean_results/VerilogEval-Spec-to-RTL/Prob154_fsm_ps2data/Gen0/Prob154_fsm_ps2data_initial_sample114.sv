module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Enum to represent the states of the FSM
enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

// Always block to handle the state transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == BYTE3) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

// Always block to handle the next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3] == 1) begin
                next_state = BYTE1;
                out_bytes = {in, 16'd0};
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
            out_bytes = {out_bytes[15:0], in};
        end
        BYTE2: begin
            next_state = BYTE3;
            out_bytes = {out_bytes[15:0], in};
        end
        BYTE3: begin
            next_state = IDLE;
        end
    endcase
end

endmodule