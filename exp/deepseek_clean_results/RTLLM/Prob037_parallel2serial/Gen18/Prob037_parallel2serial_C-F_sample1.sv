module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Shift register

    // Direct output assignments
    assign dout = data[3];
    assign valid_out = (cnt == 0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            data <= 0;
        end else begin
            cnt <= cnt + 1;
            if (cnt == 3) begin
                data <= d;          // Load new parallel data
            end else begin
                data <= {data[2:0], 1'b0};  // Rotate left
            end
        end
    end

endmodule