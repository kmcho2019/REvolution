module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;      // Load parallel input at end of serialization
                cnt       <= 2'b00;  // Reset counter
                valid_out <= 1'b1;   // First bit valid on next cycle (MSB output)
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left by 1 bit
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule