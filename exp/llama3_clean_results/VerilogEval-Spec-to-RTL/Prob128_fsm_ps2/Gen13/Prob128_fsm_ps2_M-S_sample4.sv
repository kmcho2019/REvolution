module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'd0;
        done <= 0;
    end
    else begin
        if(in[3]) begin // Potential start of message
            byte_count <= 1; // Assume this is the first byte of a message
        end
        else if(byte_count != 2'd0) begin // If we're already in a message
            byte_count <= byte_count + 1; // Increment the byte count
        end
        
        // Assert 'done' when we've received the third byte
        done <= (byte_count == 2'd2);
        
        // Reset byte_count after asserting done or if we encounter another byte with in[3]=1
        if(done || in[3]) begin
            byte_count <= in[3] ? 1 : 2'd0;
        end
    end
end

endmodule