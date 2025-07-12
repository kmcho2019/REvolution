module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

always_comb begin
    next_state = state;
    
    case(state)
        IDLE: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
            else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
            else begin
                next_state = BYTE2;
            end
        end
        BYTE2: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
            else begin
                next_state = BYTE3;
            end
        end
        BYTE3: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
            else begin
                next_state = BYTE3;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

assign done = (state == BYTE3);
endmodule