module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Select output bit according to counter (MSB first)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Reload data at the end of the 4-bit serialization
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1; // Valid high when first bit of new data output
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0; // Valid low during next bits output
            end
        end
    end

endmodule