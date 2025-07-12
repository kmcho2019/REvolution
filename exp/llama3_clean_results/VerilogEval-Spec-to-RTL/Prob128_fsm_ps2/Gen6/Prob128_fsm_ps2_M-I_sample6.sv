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
    else if(in[3] && byte_count == 2'b00) begin // Potential start byte
        byte_count <= 2'b01; // Reset counter and start counting
    end
    else if(byte_count != 2'b00 && !in[3]) begin // If we are counting bytes and current byte is not a start byte
        byte_count <= byte_count + 1'b1; // Increment counter
    end
    else if(byte_count == 2'b11) begin // If we have counted 3 bytes
        byte_count <= 2'b00; // Reset counter
    end
end

assign done = (byte_count == 2'b11);

endmodule