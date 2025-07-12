module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Output is the MSB of the data shift register
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new parallel data at start of serialization
                data      <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else begin
                // Shift data left by 1, MSB outputs serially
                data      <= {data[2:0], 1'b0};
                valid_out <= 1'b0;
                if (cnt == 2'd3)
                    cnt <= 2'd0;
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule