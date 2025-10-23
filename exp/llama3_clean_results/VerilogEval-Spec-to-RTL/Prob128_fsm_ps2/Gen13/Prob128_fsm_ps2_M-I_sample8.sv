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

logic [1:0] cnt;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        cnt <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == SEARCH && next_state == BYTE1) begin
            cnt <= 1;
        end else if (state == BYTE1 && next_state == BYTE2) begin
            cnt <= 2;
        end else begin
            cnt <= 0;
        end
        // Assert 'done' when cnt is 2 (i.e., 3 bytes received)
        done <= (cnt == 2);
    end
end

endmodule