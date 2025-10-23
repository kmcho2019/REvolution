module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] shift_reg;
    reg load;

    // Counter and load control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            load <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            load <= (cnt == 2'b11);
        end
    end

    // Shift register implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
        end else if (load) begin
            shift_reg <= d;
        end else begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end

    // Output assignments
    assign dout = shift_reg[3];
    assign valid_out = load;

endmodule