module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define a counter to track the number of bytes received
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 0;
        done <= 0;
    end
    else begin
        if (byte_count == 0) begin
            if (in[3]) begin
                byte_count <= 1; // Start counting bytes
            end
        end
        else if (byte_count < 3) begin
            byte_count <= byte_count + 1; // Increment byte count
        end
        else begin
            byte_count <= 0; // Reset byte count after 3 bytes
        end

        // Assert 'done' when the third byte is received
        done <= (byte_count == 3);
    end
end

endmodule