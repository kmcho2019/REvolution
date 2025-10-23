module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg [1:0] shift_count;
    wire load_new = (shift_count == 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            shift_count <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (load_new) begin
                // Load new parallel data
                shift_reg <= d;
                shift_count <= 2'b0;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB immediately
            end else begin
                // Shift operation
                shift_reg <= {shift_reg[2:0], 1'b0};
                shift_count <= shift_count + 1'b1;
                valid_out <= 1'b0;
                dout <= shift_reg[2];  // Next bit
            end
        end
    end

endmodule