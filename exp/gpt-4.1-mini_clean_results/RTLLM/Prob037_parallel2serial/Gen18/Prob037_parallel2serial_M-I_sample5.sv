module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // The MSB of data is the serial output
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;       // Load new data
                cnt       <= 2'b00;   // Reset counter
                valid_out <= 1'b1;    // Valid signal for MSB output
            end else begin
                data      <= {data[2:0], 1'b0}; // Shift left, LSB filled with 0
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule