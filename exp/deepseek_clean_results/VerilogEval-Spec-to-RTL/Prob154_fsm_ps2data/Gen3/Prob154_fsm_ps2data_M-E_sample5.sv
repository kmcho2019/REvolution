module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [23:0] shift_reg;
    reg [1:0] byte_count;
    reg capturing;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_count <= 2'b0;
            capturing <= 1'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            shift_reg <= {shift_reg[15:0], in};

            // Capture control logic
            if (!capturing && in[3]) begin
                capturing <= 1'b1;
                byte_count <= 2'b1;
                shift_reg <= {16'b0, in};  // Start new capture
            end else if (capturing) begin
                if (byte_count == 2'b10) begin
                    // Third byte received
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    capturing <= 1'b0;
                end
                byte_count <= byte_count + 1;
            end
        end
    end

endmodule