module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output bit is selected from data based on cnt, output MSB first
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;        // Load new parallel data
                cnt       <= 2'b0;     // Reset counter
                valid_out <= 1'b1;     // Valid output on first bit (MSB)
            end else begin
                cnt       <= cnt + 1'b1; // Increment counter
                valid_out <= 1'b0;
            end
        end
    end

endmodule