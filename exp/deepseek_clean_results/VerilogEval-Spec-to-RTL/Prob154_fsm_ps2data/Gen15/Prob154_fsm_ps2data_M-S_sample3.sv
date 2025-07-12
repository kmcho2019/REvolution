module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            done <= 1'b0;
            
            if (byte_counter == 2'b00) begin
                if (in[3]) begin
                    out_bytes <= {in, 16'b0};
                    byte_counter <= 2'b01;
                end
            end else begin
                out_bytes <= {out_bytes[15:0], in};
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