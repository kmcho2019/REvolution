module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Register the input data and maintain counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            cnt <= 2'b0;
        end else begin
            if (cnt == 2'b11) begin
                data_reg <= d;  // Load new data at end of cycle
            end
            cnt <= cnt + 1'b1;  // Always increment counter
        end
    end

    // Output logic
    assign valid_out = (cnt == 2'b00);  // Valid when starting new 4-bit sequence
    assign dout = data_reg[3 - cnt];    // Select bit from MSB to LSB

endmodule