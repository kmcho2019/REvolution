module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : cnt + 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update counter
            cnt <= next_cnt;
            
            // Handle data loading and output
            if (cnt == 2'b11) begin  // Last count - load new data
                data_reg <= d;
                dout <= d[3];        // Output MSB
            end else begin
                dout <= data_reg[2'd3 - next_cnt];  // Circular buffer access
            end
            
            // Valid output when MSB is being output
            valid_out <= (next_cnt == 2'b00);
        end
    end

endmodule