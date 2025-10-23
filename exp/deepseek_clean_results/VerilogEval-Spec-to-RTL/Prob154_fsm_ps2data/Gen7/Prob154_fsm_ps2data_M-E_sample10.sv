module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;

    // Counter-based state tracking
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            shift_reg <= 24'bx;
        end else begin
            case (byte_counter)
                2'b00: begin // Waiting for start byte
                    if (in[3]) begin
                        shift_reg <= {in, 16'b0}; // Store first byte at MSB
                        byte_counter <= 2'b01;
                    end
                end
                2'b01: begin // First byte received
                    shift_reg <= {shift_reg[23:16], in, 8'b0}; // Shift in second byte
                    byte_counter <= 2'b10;
                end
                2'b10: begin // Second byte received
                    shift_reg <= {shift_reg[23:8], in}; // Shift in third byte
                    byte_counter <= 2'b11;
                end
                default: begin // Third byte received (2'b11)
                    byte_counter <= 2'b00; // Reset counter
                end
            endcase
        end
    end

    // Output assignments
    assign out_bytes = (byte_counter == 2'b11) ? shift_reg : 24'bx;
    assign done = (byte_counter == 2'b11);

endmodule