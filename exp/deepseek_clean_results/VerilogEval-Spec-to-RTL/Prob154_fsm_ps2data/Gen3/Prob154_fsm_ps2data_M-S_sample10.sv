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
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt == 2'b10); // Done after third byte
            
            if (cnt == 2'b0) begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    cnt <= 2'b01;
                end
            end else if (cnt == 2'b01) begin
                out_bytes[15:8] <= in;
                cnt <= 2'b10;
            end else begin
                out_bytes[7:0] <= in;
                cnt <= 2'b0;
            end
        end
    end

endmodule