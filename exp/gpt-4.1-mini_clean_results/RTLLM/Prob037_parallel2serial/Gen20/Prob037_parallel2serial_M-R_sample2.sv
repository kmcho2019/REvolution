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
            cnt       <= 2'd3;      // Initialize so that data loads immediately after reset
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;    // Load new data on last bit output
                cnt       <= 2'd0; // Reset counter
                valid_out <= 1'b1; // Output is valid at the load cycle (MSB output)
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left by 1 bit (MSB moves out)
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule