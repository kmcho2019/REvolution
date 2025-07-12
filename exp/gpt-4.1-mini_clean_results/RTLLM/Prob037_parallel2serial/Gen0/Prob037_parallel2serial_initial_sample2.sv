module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;
    reg [1:0] cnt; // 2-bit counter to count 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data      <= 4'b0;
            cnt       <= 2'b11; // So that on first clock with rst_n=1, data is loaded
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit of current data output, load new data and reset counter
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
                dout      <= d[3]; // MSB of new input
            end else begin
                // Shift data left circularly and output next bit
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
                dout      <= data[3];
            end
        end
    end

endmodule