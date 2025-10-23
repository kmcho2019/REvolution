module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 0;
            done <= 0;
        end else if (in[3] || byte_counter != 0) begin
            if (byte_counter == 2) begin
                byte_counter <= 0;
                done <= 1;
            end else begin
                byte_counter <= byte_counter + 1;
                done <= 0;
            end
        end else begin
            done <= 0;
        end
    end

endmodule