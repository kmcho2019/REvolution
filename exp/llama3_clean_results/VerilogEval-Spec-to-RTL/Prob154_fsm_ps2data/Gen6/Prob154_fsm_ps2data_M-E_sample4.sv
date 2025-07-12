module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_counter;
reg [23:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        byte_counter <= 0;
        shift_register <= 0;
        done <= 0;
    end else begin
        if (in[3] && byte_counter == 0) begin
            shift_register <= {in, 16'd0};
            byte_counter <= 1;
        end else if (byte_counter > 0 && byte_counter < 3) begin
            shift_register <= {shift_register[15:0], in};
            byte_counter <= byte_counter + 1;
        end
        if (byte_counter == 3) begin
            out_bytes <= shift_register;
            done <= 1;
            byte_counter <= 0;
            shift_register <= 0;
        end else begin
            done <= 0;
        end
    end
end

endmodule