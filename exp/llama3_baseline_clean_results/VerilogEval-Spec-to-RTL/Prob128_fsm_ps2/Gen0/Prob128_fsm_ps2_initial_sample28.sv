module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output        done
);

// Define the states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    done = 1'b0;

    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            done = 1'b1;
            if (in[3]) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule