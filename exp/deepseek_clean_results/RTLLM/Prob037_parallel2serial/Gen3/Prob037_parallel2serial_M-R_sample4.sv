module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [1:0] cycle_count;

    // Shift register and cycle counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cycle_count <= 2'b0;
        end else begin
            if (cycle_count == 2'b11) begin
                shift_reg <= d;  // Load new parallel data
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Rotate left
            end
            cycle_count <= cycle_count + 1'b1;
        end
    end

    // Output assignments
    assign valid_out = (cycle_count == 2'b00);
    assign dout = shift_reg[3];  // Always output MSB

endmodule