module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] reg_data;

    // Output the bit indexed by 3 - cnt from the registered data
    assign dout = reg_data[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            reg_data  <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b0;
                reg_data  <= d;        // Capture new data at end of sequence
                valid_out <= 1'b1;     // Assert valid at first bit output cycle
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule