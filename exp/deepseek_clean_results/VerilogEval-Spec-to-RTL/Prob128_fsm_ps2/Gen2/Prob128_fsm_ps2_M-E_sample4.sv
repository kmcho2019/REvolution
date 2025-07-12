module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [23:0] msg_shift_reg;
    reg [1:0] byte_counter;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            msg_shift_reg <= 24'b0;
            byte_counter <= 2'b0;
            done_reg <= 1'b0;
        end else begin
            // Shift in new byte
            msg_shift_reg <= {msg_shift_reg[15:0], in};

            // Counter logic
            if (byte_counter == 2'b10) begin
                // After 3 bytes, reset counter
                byte_counter <= 2'b0;
                done_reg <= 1'b1;
            end else if (byte_counter == 2'b00 && in[3]) begin
                // Valid start byte
                byte_counter <= byte_counter + 1;
                done_reg <= 1'b0;
            end else if (byte_counter != 2'b00) begin
                // Continue counting
                byte_counter <= byte_counter + 1;
                done_reg <= 1'b0;
            end else begin
                // Waiting for start byte
                done_reg <= 1'b0;
            end
        end
    end

    assign done = done_reg;

endmodule