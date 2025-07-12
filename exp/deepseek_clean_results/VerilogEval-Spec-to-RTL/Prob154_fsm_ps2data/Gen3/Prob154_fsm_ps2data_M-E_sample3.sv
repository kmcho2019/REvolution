module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;
    reg collecting;

    // Shift register implementation
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            collecting <= 1'b0;
        end else begin
            if (!collecting && in[3]) begin
                // Start new message
                collecting <= 1'b1;
                byte_counter <= 2'b00;
                out_bytes <= {in, 16'b0};  // Shift in first byte
            end else if (collecting) begin
                if (byte_counter == 2'b10) begin
                    // Message complete
                    collecting <= 1'b0;
                    out_bytes <= {out_bytes[15:0], in};  // Shift in last byte
                end else begin
                    // Shift in middle byte
                    byte_counter <= byte_counter + 1;
                    out_bytes <= {out_bytes[15:0], in};
                end
            end
        end
    end

    // Done is combinatorial and asserted when counter reaches 2 and we're collecting
    assign done = collecting && (byte_counter == 2'b10);

endmodule