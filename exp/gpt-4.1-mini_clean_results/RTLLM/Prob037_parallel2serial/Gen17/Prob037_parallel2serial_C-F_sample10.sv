module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // dout is the bit at position (3 - cnt) of the registered data, MSB first
    assign dout = data_reg[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data_reg  <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'd0;
                data_reg  <= d;      // Capture parallel input at end of current serialization cycle
                valid_out <= 1'b1;   // Assert valid_out on first bit output next cycle (cnt=0)
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule