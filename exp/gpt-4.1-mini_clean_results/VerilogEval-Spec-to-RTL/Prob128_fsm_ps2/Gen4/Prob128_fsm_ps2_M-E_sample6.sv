module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count;  // counts 0 to 3 bytes received

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            
            if (byte_count == 2'b00) begin
                // waiting for first byte with in[3]=1 to start message
                if (in[3]) begin
                    byte_count <= 2'b01;
                end
            end else if (byte_count < 2'b11) begin
                // counting bytes 2 and 3 of message
                byte_count <= byte_count + 1;
                if (byte_count == 2'b10) begin
                    done <= 1'b1; // after third byte received
                    byte_count <= 2'b00; // reset counter for next message
                end
            end
        end
    end

endmodule