module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] byte_count;
logic [7:0] prev_in;
logic new_byte;
logic first_byte_valid;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
        prev_in <= 8'b0;
        first_byte_valid <= 1'b0;
    end
    else begin
        if (in !== prev_in) begin // Check if a new byte has been received
            new_byte <= 1'b1;
            prev_in <= in;
        end
        else begin
            new_byte <= 1'b0;
        end
        
        case(byte_count)
            2'b00: begin // IDLE state
                if(in[3]) begin
                    byte_count <= 2'b01; // Transition to BYTE1 if in[3] = 1
                    first_byte_valid <= 1'b1;
                end
            end
            2'b01: begin // BYTE1 state
                if(new_byte) byte_count <= 2'b10; // Transition to BYTE2 if new byte
            end
            2'b10: begin // BYTE2 state
                if(new_byte) byte_count <= 2'b11; // Transition to BYTE3 if new byte
            end
            2'b11: begin // BYTE3 state
                if(new_byte) begin
                    byte_count <= 2'b00; // Reset to IDLE
                    first_byte_valid <= 1'b0;
                end
            end
            default: byte_count <= 2'b00; // Default to IDLE if unexpected state
        endcase
    end
end

assign done = (byte_count == 2'b11) && new_byte && first_byte_valid;

endmodule