module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    assign dout = data[3];  // MSB is output bit

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data      <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;       // latch input data at start
                valid_out <= 1'b1;   // valid during whole 4 cycles
                cnt       <= cnt + 1'b1;
            end else if (cnt < 2'd3) begin
                data      <= {data[2:0], 1'b0}; // shift left, MSB moves out
                valid_out <= 1'b1;   // valid still asserted
                cnt       <= cnt + 1'b1;
            end else begin
                // cnt == 3, last bit output
                data      <= {data[2:0], 1'b0};
                valid_out <= 1'b1;
                cnt       <= 2'd0;    // reset counter next cycle to reload d
            end
        end
    end

endmodule