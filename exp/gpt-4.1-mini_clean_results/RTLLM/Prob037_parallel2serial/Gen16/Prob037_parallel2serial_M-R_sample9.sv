module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // dout is the MSB of the shift register data
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;       // Load parallel data into shift register
                valid_out <= 1'b1;   // Assert valid_out on loading new data
                cnt       <= cnt + 1;
            end else begin
                data      <= {data[2:0], 1'b0};  // Shift left by one, MSB out
                valid_out <= 1'b0;
                if (cnt == 2'd3)
                    cnt <= 2'b0;
                else
                    cnt <= cnt + 1;
            end
        end
    end

endmodule