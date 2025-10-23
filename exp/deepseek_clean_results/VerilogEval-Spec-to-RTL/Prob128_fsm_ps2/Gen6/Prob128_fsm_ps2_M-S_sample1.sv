module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            done <= 1'b0;
        end else begin
            if (byte_counter == 2'b10) begin
                byte_counter <= 2'b00;
                done <= 1'b1;
            end else if (byte_counter == 2'b00 && in[3]) begin
                byte_counter <= 2'b01;
                done <= 1'b0;
            end else if (byte_counter != 2'b00) begin
                byte_counter <= byte_counter + 1'b1;
                done <= 1'b0;
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule