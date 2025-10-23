module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // Combined state and byte counter (0=IDLE, 1=first byte, 2=second byte)
    reg [1:0] byte_cnt;
    
    // Shift register for accumulating bytes
    reg [23:0] msg_shift_reg;
    
    // Combinatorial done signal
    assign done = (byte_cnt == 2'b10) && !reset;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b00;
            msg_shift_reg <= 24'b0;
        end else begin
            case (byte_cnt)
                2'b00: begin // IDLE state
                    if (in[3]) begin
                        msg_shift_reg <= {in, 16'b0}; // Store first byte
                        byte_cnt <= 2'b01;
                    end
                end
                
                2'b01: begin // First byte received
                    msg_shift_reg <= {msg_shift_reg[23:16], in, 8'b0}; // Shift in second byte
                    byte_cnt <= 2'b10;
                end
                
                2'b10: begin // Second byte received
                    msg_shift_reg <= {msg_shift_reg[23:8], in}; // Shift in third byte
                    byte_cnt <= 2'b00; // Return to IDLE
                end
            endcase
        end
    end

    // Output is valid only when done is asserted
    always @(*) begin
        if (done) begin
            out_bytes = msg_shift_reg;
        end else begin
            out_bytes = 24'bx; // Don't-care when not done
        end
    end

endmodule