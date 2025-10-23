module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] byte_cnt;

    always @(posedge clk) begin
        done <= 1'b0;
        if (reset) begin
            byte_cnt  <= 2'd0;
            out_bytes <= 24'd0;
        end else begin
            if (byte_cnt == 2'd0) begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_cnt <= 2'd1;
                end
            end else if (byte_cnt == 2'd1) begin
                out_bytes[15:8] <= in;
                byte_cnt <= 2'd2;
            end else if (byte_cnt == 2'd2) begin
                out_bytes[7:0] <= in;
                done <= 1'b1;
                byte_cnt <= 2'd0;
            end
        end
    end

endmodule