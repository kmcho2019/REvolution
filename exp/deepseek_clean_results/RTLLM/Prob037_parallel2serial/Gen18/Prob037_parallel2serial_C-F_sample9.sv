module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] shift_reg; // Shift register storing current data

    assign dout = shift_reg[3]; // Always output MSB
    assign valid_out = (cnt == 0); // Valid when loading new data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            shift_reg <= 0;
        end else begin
            if (cnt == 3) begin
                // Load new data at end of cycle
                shift_reg <= d;
                cnt <= 0;
            end else begin
                // Shift left otherwise
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt <= cnt + 1;
            end
        end
    end

endmodule