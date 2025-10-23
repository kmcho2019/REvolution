module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg collecting;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            collecting <= 1'b0;
            shift_reg <= 24'bx;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (!collecting && in[3]) begin
                // Start collecting when we see in[3]=1
                collecting <= 1'b1;
                shift_reg <= {in, 16'b0};  // Shift in first byte
                byte_counter <= 2'b01;
            end else if (collecting) begin
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[23:16], shift_reg[15:8], in};
                    done <= 1'b1;
                    collecting <= 1'b0;
                    byte_counter <= 2'b00;
                end else begin
                    // Shift in next byte
                    shift_reg <= {shift_reg[15:0], in};
                    byte_counter <= byte_counter + 1;
                end
            end
        end
    end

endmodule