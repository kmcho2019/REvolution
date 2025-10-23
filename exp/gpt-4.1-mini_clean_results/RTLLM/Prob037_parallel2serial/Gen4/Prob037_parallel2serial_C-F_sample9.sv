module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output bit indexed by cnt, MSB first: bit 3 - cnt
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;        // Load new parallel input at the end of serialization
                cnt       <= 2'b0;     // Reset counter to start new 4-bit sequence
                valid_out <= 1'b1;     // Valid output on first serialized bit (MSB)
            end else begin
                cnt       <= cnt + 1'b1;  // Increment bit index
                valid_out <= 1'b0;        // Valid only on first output bit of new data
            end
        end
    end

endmodule