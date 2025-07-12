module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_counter;

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
        end else begin
            case (byte_counter)
                2'b00: byte_counter <= in[3] ? 2'b01 : 2'b00;  // Wait for start byte
                2'b11: byte_counter <= in[3] ? 2'b01 : 2'b00;  // After 3rd byte, check for new start
                default: byte_counter <= byte_counter + 1;     // Count through bytes 1-3
            endcase
        end
    end

    // Done is high when we're about to receive the 3rd byte (counter=2)
    assign done = (byte_counter == 2'b10);

endmodule