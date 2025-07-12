module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    // Counter and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                data_reg <= d;  // Load new parallel data
            end
            cnt <= cnt + 1'b1;
        end
    end

    // Output assignments
    assign valid_out = (cnt == 2'b00);
    assign dout = data_reg[3 - cnt];  // Select bit based on counter (MSB first)

endmodule