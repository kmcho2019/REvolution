module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // On reset or at the end of serialization (cnt == 3), load data and reset counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;     // Load new parallel data
                cnt       <= 2'b0;  // Reset counter to zero
                valid_out <= 1'b1;  // Valid high when loading new data (MSB output)
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left, fill LSB with 0 (MSB shifted out)
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

    assign dout = data[3]; // MSB always output serially

endmodule