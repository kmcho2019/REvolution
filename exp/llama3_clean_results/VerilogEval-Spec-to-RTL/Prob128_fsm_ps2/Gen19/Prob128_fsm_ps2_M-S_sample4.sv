module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state, next_state;

always_comb begin
    next_state = state;
    
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 2'd1; // Transition to BYTE1
            end
        end
        2'd1: begin // BYTE1
            next_state = 2'd2; // Transition to BYTE2
        end
        2'd2: begin // BYTE2
            next_state = 2'd0; // Transition back to SEARCH
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
    end
    else begin
        state <= next_state;
    end
end

// Assert 'done' when in state BYTE2
assign done = (state == 2'd2);

endmodule