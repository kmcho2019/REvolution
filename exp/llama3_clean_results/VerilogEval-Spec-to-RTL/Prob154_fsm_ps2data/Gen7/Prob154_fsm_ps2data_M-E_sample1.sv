module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] byte1, byte2;
reg start_message, shift_enable;
reg [1:0] count;

// First stage: Check for start of message
always @(posedge clk) begin
    if (reset) begin
        start_message <= 1'b0;
        byte1 <= 8'b0;
    end else begin
        if (in[3]) begin
            byte1 <= in;
            start_message <= 1'b1;
        end
    end
end

// Second stage: Shift bytes
always @(posedge clk) begin
    if (reset) begin
        shift_enable <= 1'b0;
        byte2 <= 8'b0;
        count <= 2'b00;
    end else begin
        if (start_message) begin
            shift_enable <= 1'b1;
            count <= 2'b01;
            byte2 <= byte1;
        end else if (shift_enable) begin
            if (count == 2'b01) begin
                out_bytes[23:16] <= byte1;
                out_bytes[15:8] <= in;
                count <= 2'b10;
            end else if (count == 2'b10) begin
                out_bytes[7:0] <= byte2;
                count <= 2'b00;
                shift_enable <= 1'b0;
            end
        end
    end
end

// Third stage: Output result
always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else begin
        if (count == 2'b10) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule