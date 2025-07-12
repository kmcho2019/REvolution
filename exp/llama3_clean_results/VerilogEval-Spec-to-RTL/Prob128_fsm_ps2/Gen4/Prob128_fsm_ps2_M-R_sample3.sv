module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Current state of the FSM (IDLE or COUNT)
logic [1:0] state;
// Counter for bytes received in a message
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // IDLE state
        byte_count <= 2'b00;
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if(in[3]) begin
                    state <= 2'b01; // Transition to COUNT state
                    byte_count <= 1'b1;
                end
            end
            2'b01: begin // COUNT state
                if(byte_count == 2'b10) begin
                    state <= 2'b00; // Transition back to IDLE state after 3 bytes
                    byte_count <= 2'b00;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end
        endcase
    end
end

assign done = (state == 2'b01 && byte_count == 2'b10);

endmodule