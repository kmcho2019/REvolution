module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [23:0] shift_reg;
    reg collecting;
    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            collecting <= 1'b0;
            byte_count <= 2'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            if (collecting) begin
                // Shift in new byte and increment count
                shift_reg <= {shift_reg[15:0], in};
                byte_count <= byte_count + 1'b1;

                // Check if message complete
                if (byte_count == 2'b10) begin
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    collecting <= 1'b0;
                end
            end else if (in[3]) begin
                // Start new message collection
                shift_reg[23:16] <= in;
                byte_count <= 2'b01;
                collecting <= 1'b1;
            end
        end
    end

endmodule