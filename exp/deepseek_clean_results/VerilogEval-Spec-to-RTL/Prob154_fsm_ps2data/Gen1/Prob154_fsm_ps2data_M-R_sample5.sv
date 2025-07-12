module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg [23:0] byte_shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
            byte_shift_reg <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            // Counter logic
            if (byte_counter == 2'b0) begin
                if (in[3]) begin
                    byte_counter <= 2'b1;
                    byte_shift_reg[23:16] <= in;
                end
            end else begin
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    out_bytes <= {byte_shift_reg[23:8], in};
                    done <= 1'b1;
                    byte_counter <= 2'b0;
                end else begin
                    // Second byte received
                    byte_shift_reg[15:8] <= in;
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule