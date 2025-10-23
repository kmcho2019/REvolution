module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
    end
    else begin
        case(byte_count)
            2'b00: begin // IDLE state
                if(in[3]) byte_count <= 2'b01; // Transition to BYTE1 if in[3] = 1
            end
            2'b01: byte_count <= 2'b10; // Transition to BYTE2
            2'b10: byte_count <= 2'b11; // Transition to BYTE3
            2'b11: byte_count <= 2'b00; // Reset to IDLE
            default: byte_count <= 2'b00; // Default to IDLE if unexpected state
        endcase
    end
end

assign done = (byte_count == 2'b11) && !reset;

endmodule