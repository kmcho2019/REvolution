module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_count;  // Tracks 0, 1, or 2 bytes received in current message

    // Counter update logic
    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
        end else begin
            case (byte_count)
                2'b00: byte_count <= in[3] ? 2'b01 : 2'b00;  // Start counting if in[3]=1
                2'b01: byte_count <= 2'b10;                   // Second byte
                2'b10: byte_count <= 2'b00;                   // Third byte - reset counter
                default: byte_count <= 2'b00;
            endcase
        end
    end

    // Done is asserted when we've just received the third byte
    assign done = (byte_count == 2'b10) && !reset;

endmodule