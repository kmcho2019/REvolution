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
            data      <= 4'b0;
            cnt       <= 2'd3;      // Set to 3 so new data loads on first cycle after reset
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;        // Load new data at cnt == 3
                cnt       <= 2'd0;
                valid_out <= 1'b1;    // Indicate valid output (MSB)
                dout      <= d[3];
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left by 1 bit
                cnt       <= cnt + 1;
                valid_out <= 1'b0;    // Only first output of 4-cycle sequence is valid_out=1
                dout      <= data[3]; // Output MSB of shifted data
            end
        end
    end

endmodule