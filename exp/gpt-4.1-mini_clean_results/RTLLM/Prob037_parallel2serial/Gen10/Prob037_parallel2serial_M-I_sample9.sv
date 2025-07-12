module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Output is always MSB of data shift register
    assign dout = data[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Start of serialization: load input data, output MSB, valid_out=1
                data      <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else if (cnt == 2'd3) begin
                // Last bit sent this cycle: shift data, clear valid_out, reset cnt next cycle
                data      <= {data[2:0], 1'b0};
                valid_out <= 1'b0;
                cnt       <= 2'b0;
            end else begin
                // Middle bits: shift data, valid_out=0, increment cnt
                data      <= {data[2:0], 1'b0};
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule