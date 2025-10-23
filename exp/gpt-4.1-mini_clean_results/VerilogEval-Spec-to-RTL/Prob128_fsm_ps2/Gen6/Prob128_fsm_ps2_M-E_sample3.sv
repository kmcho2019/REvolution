module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count;  // counts how many bytes received in current message (0 to 3)

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            
            if (byte_count == 0) begin
                // Waiting for start byte with in[3] = 1
                if (in[3]) begin
                    byte_count <= 2'b01; // first byte detected
                end else begin
                    byte_count <= 2'b00; // remain waiting
                end
            end else begin
                // Counting subsequent bytes
                if (byte_count == 2) begin
                    done <= 1'b1;       // third byte received
                    byte_count <= 2'b00; // reset counter to search for next message
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end
        end
    end

endmodule