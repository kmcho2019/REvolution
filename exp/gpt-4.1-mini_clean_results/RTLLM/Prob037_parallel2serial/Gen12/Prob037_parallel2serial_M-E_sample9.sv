module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Output MSB first: dout = data_reg[3 - cnt]
    assign dout = data_reg[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'b0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data and assert valid_out indicating MSB output valid
                data_reg  <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule