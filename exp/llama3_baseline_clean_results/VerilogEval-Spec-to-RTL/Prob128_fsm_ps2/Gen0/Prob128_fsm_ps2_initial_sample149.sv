module TopModule (
    input           clk,
    input           reset,
    input   [7:0]    in,
    output          done
);

// Define states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    DONE
} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinatorial logic
always_comb begin
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
            next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic
assign done = (state == DONE);

endmodule