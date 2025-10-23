module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

enum logic [1:0] {
    SEARCH,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

logic [1:0] byte_count;

always_comb begin
    next_state = state;
    case(state)
        SEARCH: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
        end
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = BYTE3;
        BYTE3: next_state = SEARCH;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        byte_count <= 0;
    end else begin
        state <= next_state;
        case(state)
            SEARCH: begin
                if(in[3]) begin
                    byte_count <= 1;
                end
            end
            BYTE1: byte_count <= 2;
            BYTE2: byte_count <= 3;
            BYTE3: byte_count <= 0;
        endcase
    end
end

assign done = (state == BYTE3);

endmodule