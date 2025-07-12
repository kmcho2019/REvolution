module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;    // Registered parallel data
    reg [1:0] cnt;     // 2-bit counter

    // Output bit selected from registered data, MSB first
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            data      <= 4'd0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data at end of previous sequence
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;  // Valid asserted at start of serialization
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule