module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;    // Shift register holding data
    reg [1:0] cnt;     // 2-bit counter for bits 0 to 3

    // Output is always the MSB of data (bit 3)
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd3;     // Start with cnt=3 to load new data on first cycle
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;      // Load new parallel data
                cnt       <= 2'd0;
                valid_out <= 1'b1;  // Valid output on load cycle (MSB output)
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left logically (MSB shifts out)
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule