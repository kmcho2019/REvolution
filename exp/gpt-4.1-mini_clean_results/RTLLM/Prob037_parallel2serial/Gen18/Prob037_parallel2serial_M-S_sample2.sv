module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Output bit is data[3 - cnt], MSB first
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            data      <= 4'd0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;       // Load new data at start of serializing
                valid_out <= 1'b1;   // Valid asserted on MSB output cycle
                cnt       <= cnt + 1'b1;
            end else if (cnt == 2'd3) begin
                valid_out <= 1'b0;
                cnt       <= 2'd0;   // Wrap counter after last bit output
            end else begin
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule