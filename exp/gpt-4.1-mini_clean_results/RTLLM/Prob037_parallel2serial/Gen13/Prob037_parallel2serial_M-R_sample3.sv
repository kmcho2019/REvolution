module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output the MSB of the shift register
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b00;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data and reset counter
                data      <= d;
                cnt       <= 2'b00;
                valid_out <= 1'b1;
            end else begin
                // Shift left to expose next bit
                data      <= {data[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule