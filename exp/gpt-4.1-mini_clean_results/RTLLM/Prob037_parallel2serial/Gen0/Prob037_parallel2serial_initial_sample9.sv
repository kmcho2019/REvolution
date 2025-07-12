module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
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
            dout <= data[3];  // Output MSB of data

            if (cnt == 2'd3) begin
                data      <= d;    // Load new parallel data
                cnt       <= 2'd0; // Reset counter
                valid_out <= 1'b1; // Valid signal high on first bit of new data
            end else begin
                // Rotate MSB to LSB by shifting left and placing old MSB at LSB
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule