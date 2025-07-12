module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'd0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;           // Load new parallel data
                dout      <= d[3];        // Output MSB
                valid_out <= 1'b1;        // Valid output during serial bits
                cnt       <= cnt + 1;     // Move to next bit
            end else if (cnt < 2'd4) begin
                data      <= data << 1;   // Shift left logically
                dout      <= data[2];     // Output next MSB after shift
                valid_out <= 1'b1;        // Valid output continues
                cnt       <= cnt + 1;
            end 
            
            if (cnt == 2'd4) begin
                cnt       <= 2'd0;        // Reset counter after 4 bits sent
                valid_out <= 1'b0;        // No valid output outside bit cycles
            end
        end
    end

endmodule