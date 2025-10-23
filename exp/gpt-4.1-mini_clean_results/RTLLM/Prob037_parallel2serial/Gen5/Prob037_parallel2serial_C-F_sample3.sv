module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output bit selected by cnt: from MSB (3) down to LSB (0)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // After outputting the last bit, load new data and reset counter
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;  // valid_out asserted when new data is loaded (MSB output)
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule