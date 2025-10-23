module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_counter;
reg start_message;
reg [23:0] message_bytes;
reg [23:0] next_message_bytes;

// Byte Detection Stage
always @(posedge clk) begin
    if (reset) begin
        start_message <= 1'b0;
    end else if (in[3]) begin
        start_message <= 1'b1;
    end else if (byte_counter == 2'b10) begin
        start_message <= 1'b0;
    end
end

// Byte Shifting Stage
always @(posedge clk) begin
    if (reset) begin
        message_bytes <= 24'b0;
    end else if (start_message) begin
        next_message_bytes[23:16] <= in;
        next_message_bytes[15:8] <= 8'b0;
        next_message_bytes[7:0] <= 8'b0;
    end else if (byte_counter == 2'b01) begin
        next_message_bytes[23:16] <= message_bytes[15:8];
        next_message_bytes[15:8] <= in;
        next_message_bytes[7:0] <= 8'b0;
    end else if (byte_counter == 2'b10) begin
        next_message_bytes[23:16] <= message_bytes[15:8];
        next_message_bytes[15:8] <= message_bytes[7:0];
        next_message_bytes[7:0] <= in;
    end
    message_bytes <= next_message_bytes;
end

// Byte Counter and Output Formation Stage
always @(posedge clk) begin
    if (reset) begin
        byte_counter <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else if (start_message) begin
        byte_counter <= 2'b01;
        done <= 1'b0;
    end else if (byte_counter == 2'b01) begin
        byte_counter <= 2'b10;
        done <= 1'b0;
    end else if (byte_counter == 2'b10) begin
        byte_counter <= 2'b00;
        out_bytes <= message_bytes;
        done <= 1'b1;
    end
end

endmodule