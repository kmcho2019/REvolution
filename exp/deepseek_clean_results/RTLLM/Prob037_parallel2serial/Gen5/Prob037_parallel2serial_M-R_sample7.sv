module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;
    
    // Continuous assignments
    assign dout = shift_reg[3];  // Always output MSB
    assign valid_out = (cnt == 2'b00);  // Valid when new data loaded
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt <= 2'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                shift_reg <= d;
                cnt <= 2'b0;
            end else begin
                // Shift left and increment counter
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt <= cnt + 1;
            end
        end
    end

endmodule