module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;
    
    // Next counter value (simpler than state machine)
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : (cnt + 1'b1);
    
    // Output selection using pointer (no physical shifting)
    assign dout = data_reg[3-cnt];
    assign valid_out = (cnt == 2'b00); // Valid only on first bit
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            
            // Only update data register when starting new conversion
            if (cnt == 2'b11) begin
                data_reg <= d;
            end
        end
    end

endmodule