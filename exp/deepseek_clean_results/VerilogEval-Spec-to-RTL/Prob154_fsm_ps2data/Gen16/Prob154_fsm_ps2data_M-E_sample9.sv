module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [23:0] message_reg;
    reg [1:0] byte_counter;

    // Combinatorial done signal
    assign done = (byte_counter == 2'b11);

    always @(posedge clk) begin
        if (reset) begin
            message_reg <= 24'bx;
            byte_counter <= 2'b00;
        end else begin
            case (byte_counter)
                2'b00: begin // Waiting for start byte
                    if (in[3]) begin
                        message_reg <= {in, 16'b0}; // Shift in first byte
                        byte_counter <= 2'b01;
                    end
                end
                
                2'b01: begin // Receiving second byte
                    message_reg <= {message_reg[23:16], in, 8'b0}; // Shift in second byte
                    byte_counter <= 2'b10;
                end
                
                2'b10: begin // Receiving third byte
                    message_reg <= {message_reg[23:8], in}; // Shift in third byte
                    byte_counter <= 2'b11;
                end
                
                2'b11: begin // Message complete
                    byte_counter <= 2'b00; // Reset for next message
                end
            endcase
        end
    end

    // Output is valid only when done is asserted
    always @(*) begin
        if (done) begin
            out_bytes = message_reg;
        end else begin
            out_bytes = 24'bx;
        end
    end

endmodule