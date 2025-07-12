module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] counter;
reg [23:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        shift_register <= 0;
        done <= 0;
    end else begin
        if (in[3] && counter == 0) begin
            shift_register[23:16] <= in;
            counter <= 1;
        end else if (counter == 1) begin
            shift_register[15:8] <= in;
            counter <= 2;
        end else if (counter == 2) begin
            shift_register[7:0] <= in;
            counter <= 0;
            done <= 1;
        end else begin
            done <= 0;
        end
        out_bytes <= shift_register;
    end
end

endmodule