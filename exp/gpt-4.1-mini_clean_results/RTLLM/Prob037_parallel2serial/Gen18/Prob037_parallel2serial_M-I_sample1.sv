module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Output bit selected from registered data from MSB to LSB
    assign dout = data_reg[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            data_reg  <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b0;
                valid_out <= 1'b1;            // Valid asserted on MSB output cycle (next cycle cnt=0)
                data_reg  <= d;               // Capture new input data at start of serialization
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule