module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using binary encoding
logic [1:0] state, next_state;

// Counter to keep track of the number of bytes received
logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    done = 0;
    
    case(state)
        2'b00: begin // SEARCH
            if(in[3]) begin
                next_state = 2'b01; // Transition to MESSAGE_receive
                next_byte_count = 1; // Reset byte count
            end
        end
        2'b01: begin // MESSAGE_receive
            next_byte_count = byte_count + 1; // Increment byte count
            
            if(byte_count == 2) begin
                next_state = 2'b00; // Transition back to SEARCH
                done = 1; // Signal receipt of a message
            end
        end
        default: begin
            next_state = 2'b00; // Reset to SEARCH state
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        byte_count <= 0;
    end
    else begin
        state <= next_state;
        byte_count <= next_byte_count;
    end
end

endmodule