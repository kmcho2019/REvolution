module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit counter for bit position
    reg [3:0] data_reg;     // Data latch
    
    // Next counter value
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : (cnt + 1'b1);
    
    // Output assignments
    assign dout = data_reg[3 - cnt];  // Direct bit selection (MSB first)
    assign valid_out = (cnt == 2'b00); // Valid on first bit
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0000;
        end else begin
            cnt <= next_cnt;
            
            // Load new data when counter wraps around
            if (cnt == 2'b11) begin
                data_reg <= d;
            end
        end
    end

endmodule