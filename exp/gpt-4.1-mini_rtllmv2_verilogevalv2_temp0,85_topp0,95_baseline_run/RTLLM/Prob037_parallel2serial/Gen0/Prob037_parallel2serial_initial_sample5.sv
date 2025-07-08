module parallel2serial (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] d,
    output reg        valid_out,
    output reg        dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Output current MSB, then load new data and reset counter
                dout      <= data[3];
                valid_out <= 1'b1;
                data      <= d;
                cnt       <= 2'b0;
            end else begin
                dout      <= data[3];
                valid_out <= (cnt == 2'b0) ? 1'b1 : 1'b0;
                // Circular left shift data by 1 bit
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule