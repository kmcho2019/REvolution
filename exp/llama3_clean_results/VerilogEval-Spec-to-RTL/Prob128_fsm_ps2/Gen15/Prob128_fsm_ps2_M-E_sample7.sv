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
    end else begin
        if(in[3] && byte_count == 2'd0) begin
            byte_count <= 2'd1; // Reset counter to 1 when a new message starts
        end else if(byte_count != 2'd0) begin
            byte_count <= byte_count + 1; // Increment counter for subsequent bytes
        end
        
        if(byte_count == 2'd3) begin
            done <= 1; // Assert 'done' when a complete message is received
        end else begin
            done <= 0;
        end
        
        if(byte_count == 2'd3 || (in[3] && byte_count != 2'd0)) begin
            byte_count <= 2'd0; // Reset counter after a message is received or a new message starts
        end
    end
end

endmodule