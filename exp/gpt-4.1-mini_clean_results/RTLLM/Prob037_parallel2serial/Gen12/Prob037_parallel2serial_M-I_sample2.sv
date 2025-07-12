module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Output the MSB (bit 3) of the shift register
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b00) begin
                data      <= d;        // Load new data at start
                valid_out <= 1'b1;     // Valid output for MSB
                cnt       <= cnt + 1;
            end else if (cnt < 2'd3) begin
                data      <= data >> 1; // Shift right to bring next bit into MSB
                valid_out <= 1'b0;      // Valid only on load cycle
                cnt       <= cnt + 1;
            end else begin
                // After last bit output, wrap counter to 0
                cnt       <= 2'b00;
                valid_out <= 1'b0;
                // data will be loaded next cycle
            end
        end
    end

endmodule