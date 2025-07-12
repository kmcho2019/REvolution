module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;
    reg valid;

    // Shift register and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt <= 2'b0;
            valid <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                shift_reg <= d;      // Load new data
                cnt <= 2'b0;
                valid <= 1'b1;      // Assert valid when loading new data
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                cnt <= cnt + 1'b1;
                valid <= 1'b0;
            end
        end
    end

    // Output assignments
    assign dout = shift_reg[3];     // Always output MSB
    assign valid_out = valid;       // Registered valid signal

endmodule