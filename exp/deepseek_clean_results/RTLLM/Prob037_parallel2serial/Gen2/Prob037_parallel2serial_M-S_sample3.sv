module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;    // 2-bit counter (0-3)
    reg [3:0] data;   // Data register

    // Counter and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data <= 4'b0;
        end else begin
            if (cnt == 2'b11)
                data <= d;      // Load new data when counter wraps
            cnt <= cnt + 1'b1;  // Always increment counter
        end
    end

    // Output assignments
    assign dout = data[3-cnt];  // MSB first (cnt=0 -> data[3])
    assign valid_out = 1'b1;    // Always valid when not in reset

endmodule