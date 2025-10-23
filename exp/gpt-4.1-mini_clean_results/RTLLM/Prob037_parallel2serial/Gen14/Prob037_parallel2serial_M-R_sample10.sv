module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    reg [1:0] cnt;

    // Synchronous counter with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 2'b00;
        end else begin
            if (cnt == 2'd3)
                cnt <= 2'b00;
            else
                cnt <= cnt + 1'b1;
        end
    end

    // valid_out is combinationally driven based on cnt
    assign valid_out = (cnt == 2'd3) ? 1'b1 : 1'b0;

    // dout selects bits from MSB to LSB indexed by counter
    assign dout = d[3 - cnt];

endmodule