module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Counter increment and data load logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'd3;      // Initialize to 3 so first increment loads data
            data <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data <= d;    // Load new parallel data
                cnt <= 2'd0;  // Reset counter to 0
                valid_out <= 1'b1;  // MSB valid cycle
            end else begin
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;  // Only first bit cycle valid
            end
        end
    end

    // Output the bit selected by cnt (MSB first)
    assign dout = data[3 - cnt];

endmodule