module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
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
                data      <= d;          // Load new parallel data at end of 4-bit output
                cnt       <= 2'b0;       // Reset bit counter
                valid_out <= 1'b1;       // Valid on first bit output (MSB)
            end else begin
                // Rotate left data bits by 1: MSB moves to LSB, preserving all bits for lower toggling
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1; // Increment bit counter
                valid_out <= 1'b0;       // Valid only on first bit of new data word
            end
        end
    end

endmodule