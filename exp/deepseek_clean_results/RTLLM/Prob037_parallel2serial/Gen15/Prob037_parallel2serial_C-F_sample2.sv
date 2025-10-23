module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data shift register

    // Counter increment with wrap-around
    wire cnt_wrap = (cnt == 2'b11);

    // Output assignments
    assign dout = data_reg[3];          // Always output MSB
    assign valid_out = cnt_wrap;        // Valid when loading new data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            if (cnt_wrap) begin
                cnt <= 2'b00;           // Reset counter
                data_reg <= d;         // Load new parallel data
            end else begin
                cnt <= cnt + 1'b1;      // Increment counter
                data_reg <= {data_reg[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule