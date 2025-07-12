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

logic [7:0] buffer [2:0];
logic [1:0] buffer_index;

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
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = SEARCH;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        buffer_index <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        case(state)
            SEARCH: begin
                if(in[3]) begin
                    buffer[0] <= in;
                    buffer_index <= 1;
                end
            end
            BYTE1: begin
                buffer[1] <= in;
                buffer_index <= 2;
            end
            BYTE2: begin
                buffer[2] <= in;
            end
            BYTE3: begin
                done <= 1;
            end
        endcase
        if (next_state == SEARCH && state != SEARCH) begin
            done <= 1;
        end else if (next_state != SEARCH) begin
            done <= 0;
        end
    end
end

endmodule