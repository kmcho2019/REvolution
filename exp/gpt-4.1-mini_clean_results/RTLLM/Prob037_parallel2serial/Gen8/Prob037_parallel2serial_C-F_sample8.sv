module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Serial output is bit indexed by (3 - cnt) to output MSB first
    assign dout = data_reg[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new parallel data and assert valid_out for MSB output
                data_reg  <= d;
                valid_out <= 1'b1;
            end else begin
                // Output next bit, valid_out low after first bit
                valid_out <= 1'b0;
            end

            // Increment counter modulo 4
            cnt <= cnt + 1'b1;
        end
    end

endmodule