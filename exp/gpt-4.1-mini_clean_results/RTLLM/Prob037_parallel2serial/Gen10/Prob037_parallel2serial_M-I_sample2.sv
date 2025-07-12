module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;    // Registered parallel data for stable serialization
    reg [1:0] cnt;     // 2-bit counter for bit index (0 to 3)

    // Output bit selected from registered data, MSB first: data[3 - cnt]
    assign dout = data[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit serialized, load new data and reset counter
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1; // valid_out asserted at start of new 4-bit serialization
            end else begin
                // Serialize next bit
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule