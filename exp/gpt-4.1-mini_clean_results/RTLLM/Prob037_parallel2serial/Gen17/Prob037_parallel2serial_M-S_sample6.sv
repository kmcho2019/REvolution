module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            data_reg  <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b00;
                data_reg  <= d;          // Load new parallel data
                valid_out <= 1'b1;       // Valid output active during all 4 bits output cycle
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b1;
            end
        end
    end

    assign dout = data_reg[3 - cnt]; // Output MSB first, down to LSB

endmodule