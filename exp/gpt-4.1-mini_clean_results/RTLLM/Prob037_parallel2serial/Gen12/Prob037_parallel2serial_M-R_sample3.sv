module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output the bit indexed by the counter (MSB first)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;       // Load new parallel data at the end of serialization
                cnt       <= 2'b0;    // Reset counter
                valid_out <= 1'b1;    // Assert valid for MSB output of new data
            end else begin
                cnt       <= cnt + 1'b1; // Increment counter
                valid_out <= 1'b0;       // Valid only during MSB output cycle
            end
        end
    end

endmodule