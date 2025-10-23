module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            data      <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;      // Load new parallel data at last bit output
                cnt       <= 2'd0;  // Reset counter
                valid_out <= 1'b1;  // Valid output for this bit
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b1;  // Valid output for bits 0,1,2 as well
            end
        end
    end

endmodule