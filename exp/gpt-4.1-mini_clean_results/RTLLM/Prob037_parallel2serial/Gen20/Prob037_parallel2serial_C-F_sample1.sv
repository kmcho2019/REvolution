module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Serial output is always the MSB of the data register
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd3;      // Initialize to 3 so first load happens on next cycle
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // On last bit sent, load new parallel data, reset counter and set valid_out
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                // Shift data left with MSB wrapped to LSB
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule