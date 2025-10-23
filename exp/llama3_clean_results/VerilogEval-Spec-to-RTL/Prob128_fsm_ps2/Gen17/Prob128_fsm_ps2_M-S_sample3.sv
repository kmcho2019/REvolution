module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// 2-bit counter to track byte sequence
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
    end
    else begin
        if(byte_count == 0) begin
            if(in[3]) begin
                byte_count <= 1; // Set byte_count to 1 when in[3] is 1
            end
        end
        else if(byte_count == 1) begin
            byte_count <= 2; // Increment byte_count
        end
        else if(byte_count == 2) begin
            byte_count <= 0; // Reset byte_count
        end
        else begin
            byte_count <= byte_count; // No change
        end
    end
end

// Assert 'done' when byte_count reaches 2
assign done = (byte_count == 2);

endmodule