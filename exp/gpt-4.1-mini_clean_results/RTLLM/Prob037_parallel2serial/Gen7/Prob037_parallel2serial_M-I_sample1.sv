module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output the bit selected by cnt from MSB (3) down to LSB (0)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;       // Load new data at start of cycle
                valid_out <= 1'b1;   // Valid is high only when new data is loaded
                cnt       <= cnt + 1'b1;
            end else if (cnt == 2'd3) begin
                valid_out <= 1'b0;   // Clear valid_out after first bit cycle
                cnt       <= 2'b0;   // Reset counter after last bit output
            end else begin
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule