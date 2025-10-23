module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;        // 2-bit binary counter (0-3)
    reg [3:0] data_reg;    // Data storage register
    wire cnt_last = (cnt == 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update counter
            cnt <= cnt + 1'b1;
            
            // Handle data loading and output
            if (cnt_last) begin
                data_reg <= d;          // Load new data
                dout <= d[3];           // Output MSB
                valid_out <= 1'b1;      // Valid when loading new data
            end else begin
                dout <= data_reg[3-cnt]; // Select current bit
                valid_out <= 1'b0;
            end
        end
    end

endmodule