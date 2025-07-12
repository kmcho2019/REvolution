module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using one-hot encoding
logic [2:0] state, next_state;

always_comb begin
    next_state = state;
    
    case(state)
        3'b001: begin // SEARCH
            if(in[3]) begin
                next_state = 3'b010; // Transition to BYTE1
            end
        end
        3'b010: begin // BYTE1
            next_state = 3'b100; // Transition to BYTE2
        end
        3'b100: begin // BYTE2
            next_state = 3'b001; // Transition back to SEARCH
        end
        default: begin
            next_state = 3'b001; // Reset to SEARCH state
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 3'b001;
    end
    else begin
        state <= next_state;
    end
end

// Assert 'done' when transitioning back to SEARCH from BYTE2
assign done = (state == 3'b100);

endmodule