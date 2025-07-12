module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output reg dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    wire [1:0] next_cnt;    // Next counter value
    
    // Counter logic
    assign next_cnt = cnt + 1'b1;
    
    // Valid output is high when we're about to load new data
    assign valid_out = (cnt == 2'b11);
    
    // Output selection using pointer arithmetic
    wire [1:0] output_sel = 2'b11 - cnt;  // MSB first (3,2,1,0)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
        end else begin
            // Update counter
            cnt <= next_cnt;
            
            // Load new data when counter wraps
            if (valid_out) begin
                data_reg <= d;
            end
            
            // Output current bit (combinational in original, registered here)
            dout <= data_reg[output_sel];
        end
    end

endmodule