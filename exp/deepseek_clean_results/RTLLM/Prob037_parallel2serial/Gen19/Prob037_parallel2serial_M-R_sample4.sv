module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [2:0] bit_sel;

    // State and data registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            bit_sel <= 3'b001;
        end else begin
            if (bit_sel[2]) begin  // Last bit processed
                data_reg <= d;      // Load new parallel data
                bit_sel <= 3'b001;  // Reset to first bit
            end else begin
                bit_sel <= {bit_sel[1:0], 1'b0};  // Rotate left
            end
        end
    end

    // Output assignments
    assign valid_out = (bit_sel == 3'b001);
    assign dout = (bit_sel[0] ? data_reg[3] :
                 (bit_sel[1] ? data_reg[2] :
                 (bit_sel[2] ? data_reg[1] : data_reg[0])));

endmodule