module parallel2serial (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] d,
    output reg        valid_out,
    output wire       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule