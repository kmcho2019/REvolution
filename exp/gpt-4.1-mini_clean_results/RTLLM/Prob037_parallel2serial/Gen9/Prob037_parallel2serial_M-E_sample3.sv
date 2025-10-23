module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Output bit is data_reg[3 - cnt], MSB first
    assign dout = data_reg[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'b0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data_reg  <= d;       // Load new data at start of cycle
                valid_out <= 1'b1;   // Indicate new valid serial data available
            end else begin
                valid_out <= 1'b0;   // Clear valid_out on other cycles
            end
            cnt <= cnt + 1'b1;       // Increment counter modulo 4
        end
    end

endmodule