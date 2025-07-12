module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output reg      done
);

reg [1:0] counter; // Counter to track the number of bytes received

always @(posedge clk) begin
    if (reset) begin
        counter <= 0; // Reset counter
        done <= 0;
    end else begin
        if (in[3] == 1'b1) begin // First byte of message
            counter <= 1;
        end else if (counter > 0) begin // Subsequent bytes
            counter <= counter + 1;
            if (counter == 3) begin
                done <= 1'b1; // Signal done after third byte
            end
        end else begin // Not in a message sequence
            counter <= 0;
        end
        if (counter != 3) begin
            done <= 0; // Ensure done is low unless a full message is received
        end
    end
end

endmodule