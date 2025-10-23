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
                // Load new data and output its MSB with valid_out=1
                data      <= d;
                dout      <= d[3];
                valid_out <= 1'b1;
                cnt       <= 2'b0;
            end else begin
                // Shift data left, output new MSB, valid_out=0
                data      <= {data[2:0], 1'b0};
                dout      <= data[3];
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule