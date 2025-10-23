module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Output bit selected from registered data MSB to LSB
    assign dout = data[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            data      <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b0;
                valid_out <= 1'b1;     // Assert valid on MSB output cycle next round
                data      <= d;        // Capture new input data at end of previous serialization
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule