module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;          // Load new parallel data
                valid_out <= 1'b1;       // Assert valid on first bit
                cnt       <= cnt + 1'b1;
            end else if (cnt == 2'd3) begin
                data      <= data << 1;  // Shift left
                valid_out <= 1'b0;
                cnt       <= 2'b0;       // Reset counter after last bit
            end else begin
                data      <= data << 1;  // Shift left
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule