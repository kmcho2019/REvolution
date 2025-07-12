module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Stage 1: Byte Detection
reg [7:0] detected_byte;
reg detect_valid;
always @(posedge clk) begin
    if (reset) begin
        detect_valid <= 1'b0;
    end else if (in[3] == 1'b1) begin
        detected_byte <= in;
        detect_valid <= 1'b1;
    end else begin
        detect_valid <= 1'b0;
    end
end

// Stage 2: Byte Buffering
reg [7:0] byte1, byte2, byte3;
reg [1:0] buffer_valid;
always @(posedge clk) begin
    if (reset) begin
        buffer_valid <= 2'b00;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else if (detect_valid) begin
        byte1 <= detected_byte;
        buffer_valid <= 2'b01;
    end else if (buffer_valid == 2'b01) begin
        byte2 <= in;
        buffer_valid <= 2'b10;
    end else if (buffer_valid == 2'b10) begin
        byte3 <= in;
        buffer_valid <= 2'b00;
    end
end

// Stage 3: Message Formation
reg [23:0] message;
always @(posedge clk) begin
    if (reset) begin
        message <= 24'b0;
    end else if (buffer_valid == 2'b10) begin
        message <= {byte1, byte2, byte3};
    end
end

// Stage 4: Output Stage
always @(posedge clk) begin
    if (reset) begin
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else if (buffer_valid == 2'b00 && message != 24'b0) begin
        out_bytes <= message;
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule