module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] byte_count;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
    end else begin
        if (in[3]) begin // Detect start of a new message
            byte_count <= 1;
        end else if (byte_count > 0) begin // Continue counting bytes
            byte_count <= byte_count + 1;
        end
    end
end

assign done = (byte_count == 3); // Assert 'done' when 3 bytes have been received

endmodule