module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg [3:0] onehot_cnt;  // One-hot counter: 0001, 0010, 0100, 1000
    wire data_valid;

    // One-hot counter implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            onehot_cnt <= 4'b0001;
        end else begin
            onehot_cnt <= {onehot_cnt[2:0], onehot_cnt[3]};
        end
    end

    // Shift register and data processing
    assign data_valid = |d;  // Only process when input data is non-zero

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else if (data_valid) begin
            if (onehot_cnt[3]) begin  // Load new data
                shift_reg <= d;
                valid_out <= 1'b1;
                dout <= d[3];
            end else begin  // Shift data
                shift_reg <= {shift_reg[2:0], 1'b0};
                valid_out <= 1'b0;
                dout <= shift_reg[3];
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule