module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] byte_counter; // 2-bit counter register
reg       message_started; // flag to track if a message has started

always @ (posedge clk) begin
    if (reset) begin
        byte_counter <= 2'b00;
        message_started <= 1'b0;
    end else begin
        if (in[3] && ~message_started) begin
            // First byte of a message detected
            message_started <= 1'b1;
            byte_counter <= 2'b01;
        end else if (message_started) begin
            // Subsequent bytes of a message
            if (byte_counter == 2'b01) begin
                byte_counter <= 2'b10;
            end else if (byte_counter == 2'b10) begin
                byte_counter <= 2'b11;
            end else if (byte_counter == 2'b11) begin
                // Message completed, reset state
                message_started <= 1'b0;
                byte_counter <= 2'b00;
            end
        end
    end
end

assign done = (byte_counter == 2'b11);

endmodule