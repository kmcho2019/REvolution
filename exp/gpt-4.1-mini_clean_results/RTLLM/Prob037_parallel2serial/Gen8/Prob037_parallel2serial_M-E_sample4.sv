module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'd0;
            cnt       <= 2'd3;  // Start from MSB bit index 3
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Last bit serialized, load new data and reset counter
                data_reg  <= d;
                cnt       <= 2'd3;
                valid_out <= 1'b1;
                dout      <= d[3];
            end else begin
                // Serialize current bit, decrement counter
                cnt       <= cnt - 1'b1;
                valid_out <= 1'b1;
                dout      <= data_reg[cnt - 1'b1];
            end
        end
    end

endmodule