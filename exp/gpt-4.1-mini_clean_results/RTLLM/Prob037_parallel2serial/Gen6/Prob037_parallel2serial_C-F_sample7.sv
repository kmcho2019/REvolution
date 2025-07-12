module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Output bit selected by counter (MSB first)
    assign dout = data_reg[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new parallel data and assert valid_out on first bit
                data_reg  <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else if (cnt == 2'd3) begin
                // Output last bit; next cycle will reload new data
                valid_out <= 1'b0;
                cnt       <= 2'b0;
            end else begin
                // Output intermediate bits, valid_out low
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule