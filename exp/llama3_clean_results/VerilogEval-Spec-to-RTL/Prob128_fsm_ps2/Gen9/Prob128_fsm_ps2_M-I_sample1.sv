module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
logic [1:0] state;
logic [1:0] byte_count;

// Initialize done signal
logic done_reg;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // IDLE
        byte_count <= 2'b00;
        done_reg <= 1'b0;
    end
    else begin
        case(state)
            2'b00: begin // IDLE
                if(in[3]) begin
                    state <= 2'b01; // Transition to COUNTING
                    byte_count <= 2'b01; // Start counting from 1
                end
            end
            2'b01: begin // COUNTING
                if(byte_count < 2'b11) begin // If not yet received 3 bytes
                    byte_count <= byte_count + 1; // Increment counter
                end
                else begin
                    state <= 2'b00; // Transition back to IDLE
                    byte_count <= 2'b00; // Reset counter
                end
            end
        endcase
        
        // Assert done signal when third byte is received
        if(state == 2'b01 && byte_count == 2'b10) begin
            done_reg <= 1'b1;
        end
        else begin
            done_reg <= 1'b0;
        end
    end
end

assign done = done_reg;

endmodule