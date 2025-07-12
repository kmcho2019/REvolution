module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;      // Holds data being serialized
    reg [1:0] cnt;       // 2-bit counter from 0 to 3

    // dout is MSB of data register
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit outputted, load new data and reset counter
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;  // Valid signal when new data loaded and first bit output
            end else begin
                // Shift data left, discard MSB (already output), pad LSB with 0
                data      <= {data[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule