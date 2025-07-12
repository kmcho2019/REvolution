module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;  // shift register holding current serializing data
    reg [1:0] cnt;   // 2-bit counter to track output bits

    // Output the MSB of the shift register as the serial output
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'd0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data into shift register
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;  // Valid output at load time (MSB output)
            end else begin
                // Shift data left by 1 bit, inserting zero at LSB (could be any bit)
                data      <= {data[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule