module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;
    reg [1:0] cnt;  // Counter from 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit output, reload parallel data
                data      <= d;
                dout      <= d[3];
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                // Output next bit
                dout      <= data[3 - cnt];
                cnt       <= cnt + 1;
                valid_out <= 1'b1;
            end
        end
    end

endmodule