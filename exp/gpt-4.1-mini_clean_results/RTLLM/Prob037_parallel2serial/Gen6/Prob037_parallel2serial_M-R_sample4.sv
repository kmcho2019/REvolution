module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // dout is selected from data_reg using cnt as index (MSB first)
    // When cnt=0 output data_reg[3], cnt=1 output data_reg[2], etc.
    assign dout = data_reg[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data on last bit output
                data_reg  <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1; // Valid asserted at first bit
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule