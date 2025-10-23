module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] byte_count;
reg prev_in3;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        prev_in3 <= 0;
    end else begin
        if (in[3] && !prev_in3) begin // Start counting when in[3] rises
            byte_count <= 1;
        end else if (byte_count > 0) begin // Continue counting until 3 bytes are received
            byte_count <= byte_count + 1;
            if (byte_count == 3) begin // Signal 'done' after receiving the third byte
                byte_count <= 0;
            end
        end
        prev_in3 <= in[3];
    end
end

assign done = (byte_count == 3);

endmodule