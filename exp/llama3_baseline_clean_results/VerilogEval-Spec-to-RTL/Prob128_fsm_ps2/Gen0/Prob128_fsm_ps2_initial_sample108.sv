module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

// Define states
enum {IDLE, BYTE1, BYTE2} state, next_state;

// Default assignments
assign done = 0;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = IDLE;
            done = 1;
        end
        default: next_state = IDLE;
    endcase
end

endmodule