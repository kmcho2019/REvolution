module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_counter;
reg [23:0] message_register;

always @(posedge clk) begin
    if (reset) begin
        byte_counter <= 0;
        message_register <= 0;
        done <= 0;
    end else begin
        case (byte_counter)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    message_register[23:16] <= in;
                    byte_counter <= 2'b01;
                end
                done <= 0;
            end
            2'b01: begin
                message_register[15:8] <= in;
                byte_counter <= 2'b10;
                done <= 0;
            end
            2'b10: begin
                message_register[7:0] <= in;
                byte_counter <= 2'b00;
                done <= 1;
                out_bytes <= message_register;
            end
            default: begin
                byte_counter <= 2'b00;
                done <= 0;
            end
        endcase
    end
end

endmodule