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
            cnt       <= 2'd0;
            data      <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            case (cnt)
                2'd0: begin
                    // Load new parallel data, output MSB immediately
                    data      <= d;
                    dout      <= d[3];
                    valid_out <= 1'b1;
                    cnt       <= cnt + 1'b1;
                end
                2'd1: begin
                    // Output bit 2
                    dout      <= data[2];
                    valid_out <= 1'b0;
                    cnt       <= cnt + 1'b1;
                end
                2'd2: begin
                    // Output bit 1
                    dout      <= data[1];
                    valid_out <= 1'b0;
                    cnt       <= cnt + 1'b1;
                end
                2'd3: begin
                    // Output bit 0
                    dout      <= data[0];
                    valid_out <= 1'b0;
                    cnt       <= 2'd0;
                end
                default: begin
                    cnt       <= 2'd0;
                    valid_out <= 1'b0;
                    dout      <= 1'b0;
                end
            endcase
        end
    end

endmodule