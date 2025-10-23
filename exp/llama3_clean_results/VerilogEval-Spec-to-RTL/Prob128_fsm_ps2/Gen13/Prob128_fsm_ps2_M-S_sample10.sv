module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state, next_state;
logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 2'd1; // Transition to MESSAGE
                next_byte_count = 2'd1; // Start counting bytes
            end
        end
        2'd1: begin // MESSAGE
            next_byte_count = byte_count + 1; // Increment byte count
            
            if(byte_count == 2'd2) begin // If three bytes received
                next_state = 2'd0; // Transition back to SEARCH
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        byte_count <= 2'd0;
        done <= 0;
    end
    else begin
        state <= next_state;
        byte_count <= next_byte_count;
        
        // Assert 'done' when transitioning back to SEARCH from MESSAGE
        done <= (state == 2'd1 && byte_count == 2'd2);
    end
end

endmodule