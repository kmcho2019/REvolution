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
    done = 0;
    
    case(state)
        2'b00: begin // SEARCH
            if(in[3]) begin
                next_state = 2'b01; // Transition to BYTE1
            end
        end
        2'b01: begin // BYTE1
            next_state = 2'b10; // Transition to BYTE2
        end
        2'b10: begin // BYTE2
            next_state = 2'b00; // Transition back to SEARCH
            done = 1; // Assert 'done' signal
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
    end
    else begin
        state <= next_state;
    end
end

endmodule