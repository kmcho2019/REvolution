module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    assign dout = shift_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 2'd3; // Initialize to 3 to trigger load at first cycle
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load parallel input, assert valid_out
                shift_reg <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                // Shift left by 1, MSB shifted out on dout
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule