module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] byte_aligned;
reg [7:0] byte_aligned_reg;
reg [23:0] message;
reg [23:0] message_reg;

always @(posedge clk) begin
    if (reset) begin
        byte_aligned <= 8'd0;
        byte_aligned_reg <= 8'd0;
        message <= 24'd0;
        message_reg <= 24'd0;
        out_bytes <= 24'd0;
        done <= 1'b0;
    end else begin
        // Byte alignment stage
        if (in[3]) begin
            byte_aligned <= in;
        end else begin
            byte_aligned <= 8'd0;
        end

        // Message formation stage
        if (byte_aligned != 8'd0) begin
            message_reg <= {byte_aligned, byte_aligned_reg, 8'd0};
        end else begin
            message_reg <= 24'd0;
        end

        // Output stage
        if (message_reg != 24'd0) begin
            message <= message_reg;
            out_bytes <= message;
            done <= 1'b1;
        end else begin
            out_bytes <= 24'd0;
            done <= 1'b0;
        end

        byte_aligned_reg <= byte_aligned;
    end
end

endmodule