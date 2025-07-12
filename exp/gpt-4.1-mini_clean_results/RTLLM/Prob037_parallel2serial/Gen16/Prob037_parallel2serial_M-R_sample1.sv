module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Shift register and data load logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'd0;
        end else if (cnt == 2'd3) begin
            data <= d;  // Load parallel input when counter resets
        end else begin
            data <= {data[2:0], 1'b0};  // Shift left, MSB out
        end
    end

    // Counter and valid_out logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else if (cnt == 2'd3) begin
            cnt       <= 2'd0;
            valid_out <= 1'b1;  // Valid when new data loaded and MSB output
        end else begin
            cnt       <= cnt + 1'b1;
            valid_out <= 1'b0;
        end
    end

    assign dout = data[3];  // MSB of data register as serial output

endmodule