module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
enum logic [1:0] {SEARCH, BYTE1, BYTE2} state, next_state;

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
    end
    else begin
        state <= next_state;
    end
end

// Assert 'done' when a message is fully received
assign done = (state == BYTE2);

endmodule