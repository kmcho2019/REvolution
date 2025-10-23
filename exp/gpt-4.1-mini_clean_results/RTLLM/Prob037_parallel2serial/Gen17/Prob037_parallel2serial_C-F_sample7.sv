module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Select bit from registered data starting from MSB down to LSB
    assign dout = data_reg[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            data_reg  <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                // On last bit output cycle:
                // Load new parallel input data, reset counter,
                // Assert valid_out as MSB bit is output this cycle
                cnt       <= 2'd0;
                data_reg  <= d;
                valid_out <= 1'b1;
            end else begin
                // For bits 2,1,0 output cycles:
                // Increment counter, valid_out low
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule