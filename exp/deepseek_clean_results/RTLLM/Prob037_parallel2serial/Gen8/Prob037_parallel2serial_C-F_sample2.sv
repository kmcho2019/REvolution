module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;
    
    // Continuous assignments for cleaner implementation
    assign dout = data_reg[3];  // Always output MSB
    assign valid_out = (cnt == 2'b00);  // Valid when new data loaded
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b11;  // Initialize to trigger load on first cycle
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load phase - directly capture input
                data_reg <= d;
                cnt <= 2'b00;
            end else begin
                // Shift phase - simple left shift
                data_reg <= {data_reg[2:0], 1'b0};
                cnt <= cnt + 1;
            end
        end
    end

endmodule