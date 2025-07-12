module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_counter;
    reg done_reg;

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
        end else if (byte_counter == 2'b10) begin
            // Reset counter after third byte
            byte_counter <= (in[3]) ? 2'b01 : 2'b00;
        end else if (in[3] && byte_counter == 2'b00) begin
            // Start new message
            byte_counter <= 2'b01;
        end else if (byte_counter != 2'b00) begin
            // Count subsequent bytes
            byte_counter <= byte_counter + 1;
        end
    end

    // Done signal generation (registered)
    always @(posedge clk) begin
        if (reset) begin
            done_reg <= 1'b0;
        end else begin
            done_reg <= (byte_counter == 2'b10);
        end
    end

    assign done = done_reg;

endmodule