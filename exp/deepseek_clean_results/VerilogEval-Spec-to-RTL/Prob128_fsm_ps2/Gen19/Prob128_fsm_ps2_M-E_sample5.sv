module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_counter;
    reg prev_in3;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            prev_in3 <= 1'b0;
            done <= 1'b0;
        end else begin
            // Edge detection for in[3]
            prev_in3 <= in[3];
            done <= 1'b0;

            // Detect rising edge of in[3] or continue counting
            if ((in[3] && !prev_in3) || (byte_counter != 0)) begin
                if (byte_counter == 2'b10) begin
                    done <= 1'b1;
                    byte_counter <= 2'b00;
                end else begin
                    byte_counter <= byte_counter + 1;
                end
            end
        end
    end

endmodule