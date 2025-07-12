module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;
    
    // Clock gating control
    wire cnt_en = (cnt != 2'b11) || valid_out;
    
    // Output assignments
    assign dout = data_reg[3-cnt];  // Direct bit selection
    assign valid_out = (cnt == 2'b00);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            // Update counter only when needed
            if (cnt_en) begin
                cnt <= (cnt == 2'b11) ? 2'b00 : (cnt + 1'b1);
            end
            
            // Load new data when counter wraps
            if (cnt == 2'b11) begin
                data_reg <= d;
            end
        end
    end

endmodule