module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg shifting;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            shifting <= 1'b0;
        end else begin
            if (!shifting) begin
                shift_reg <= d;          // Load new parallel data
                shifting <= 1'b1;        // Start shifting
            end else begin
                if (shift_reg != 4'b0) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};  // Rotate left
                end else begin
                    shifting <= 1'b0;    // Stop shifting when done
                end
            end
        end
    end

    // Output assignments
    assign valid_out = (shift_reg != 4'b0) && (shift_reg[2:0] == 3'b0);
    assign dout = shift_reg[3];  // Always output MSB

endmodule