module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;
    
    // Combinational done signal
    assign done = (byte_counter == 2'b10) && !reset;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            shift_reg <= 24'bx;
        end else begin
            // Check for new start byte (in[3]=1)
            if (in[3] && (byte_counter == 2'b00)) begin
                // Start new message
                shift_reg <= {in, 16'b0};
                byte_counter <= 2'b01;
            end else if (byte_counter > 0) begin
                // Shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                
                // Update counter or reset if new start detected
                if (in[3] && (byte_counter != 2'b10)) begin
                    // Early termination - new start byte detected
                    shift_reg <= {in, 16'b0};
                    byte_counter <= 2'b01;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

    // Output the collected bytes when done
    always @(*) begin
        if (done) begin
            out_bytes = shift_reg;
        end else begin
            out_bytes = 24'bx;
        end
    end

endmodule