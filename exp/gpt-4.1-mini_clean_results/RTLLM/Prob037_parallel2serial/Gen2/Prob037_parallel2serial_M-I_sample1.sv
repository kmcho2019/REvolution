module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'd0;
            cnt       <= 2'd3;        // Set to 3 to load data on first cycle
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;           // Load new parallel data
                dout      <= d[3];        // Output MSB first
                valid_out <= 1'b1;        // Valid output available
                cnt       <= 2'd0;        // Reset counter for next bits
            end else begin
                data      <= {data[2:0], data[3]}; // Shift left with wrap-around
                dout      <= data[3];               // Output MSB
                valid_out <= 1'b1;                  // Valid output available
                cnt       <= cnt + 1;
            end
        end
    end

endmodule