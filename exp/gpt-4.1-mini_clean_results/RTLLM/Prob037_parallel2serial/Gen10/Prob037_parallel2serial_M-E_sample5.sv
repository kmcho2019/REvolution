module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output selected bit from data based on cnt (MSB first)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b00) begin
                data      <= d;        // Load new data at cnt=0
                valid_out <= 1'b1;    // Assert valid on first output bit
            end else begin
                valid_out <= 1'b0;    // Deassert valid for other bits
            end

            // Increment counter, wrap around after 3
            cnt <= cnt + 1'b1;
        end
    end

endmodule