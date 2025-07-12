module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data;         // Shift register
    wire cnt_max;           // Terminal count indicator
    wire shift_en;          // Shift enable signal

    // Output assignments
    assign dout = data[3];  // Always output MSB
    assign valid_out = (cnt == 2'b00);
    assign cnt_max = (cnt == 2'b11);
    assign shift_en = !cnt_max;  // Shift when not loading

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data <= 4'b0000;
        end else begin
            // Counter always increments
            cnt <= cnt + 1'b1;
            
            // Optimized shift/load operation with clock gating
            if (cnt_max) begin
                data <= d;  // Parallel load
            end else if (shift_en) begin
                data <= {data[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule