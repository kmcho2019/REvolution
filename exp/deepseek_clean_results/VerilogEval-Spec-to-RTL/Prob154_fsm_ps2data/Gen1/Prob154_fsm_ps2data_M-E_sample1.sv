module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;
    reg collecting;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            shift_reg <= 24'b0;
            collecting <= 1'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            if (collecting) begin
                // Shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    collecting <= 1'b0;
                    byte_counter <= 2'b00;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end else if (in[3]) begin
                // Start new message collection
                collecting <= 1'b1;
                shift_reg <= {16'b0, in};
                byte_counter <= 2'b00;
            end
        end
    end

endmodule