module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b00;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (cnt == 2'b00) begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    cnt <= 2'b01;
                end
            end
            else if (cnt == 2'b01) begin
                out_bytes[15:8] <= in;
                cnt <= 2'b10;
            end
            else begin // cnt == 2'b10
                out_bytes[7:0] <= in;
                done <= 1'b1;
                cnt <= 2'b00;
            end
        end
    end

endmodule