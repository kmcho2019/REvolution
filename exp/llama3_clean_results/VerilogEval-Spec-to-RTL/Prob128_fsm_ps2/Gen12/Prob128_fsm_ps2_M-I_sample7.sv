module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Simplified state encoding using 2 bits
typedef enum logic [1:0] {
    SEARCH = 2'd0,
    BYTE1  = 2'd1,
    BYTE2  = 2'd2
} state_t;

state_t state, next_state;

always_comb begin
    next_state = state;
    case(state)
        SEARCH: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = SEARCH;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        done <= 0;
    end else begin
        state <= next_state;
        // Assert 'done' when transitioning from BYTE2 to SEARCH
        done <= (next_state == SEARCH && state == BYTE2);
    end
end

endmodule