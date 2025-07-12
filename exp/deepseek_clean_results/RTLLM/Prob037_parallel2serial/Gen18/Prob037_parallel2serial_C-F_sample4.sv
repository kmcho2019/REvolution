module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Shift register
    wire cnt_max;       // Terminal count indicator

    assign dout = data[3];
    assign valid_out = (cnt == 2'b00);
    assign cnt_max = (cnt == 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data <= 4'b0000;
        end else begin
            // Counter always increments
            cnt <= cnt + 1'b1;
            
            // Optimized shift/load operation
            if (cnt_max) begin
                data <= d;          // Parallel load
            end else begin
                data <= {data[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule