module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output wire dout
);

    reg [1:0] cnt;      // 2-bit binary counter (0-3)
    reg [3:0] data;     // Shift register
    wire load_en;       // Load enable signal

    // Counter and control logic
    assign load_en = (cnt == 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            cnt <= cnt + 1'b1;
            
            // Shift register update with clock gating effect
            if (load_en)
                data <= d;
            else
                data <= {data[2:0], 1'b0};
            
            // Registered valid signal for better timing
            valid_out <= (cnt == 2'b00);
        end
    end

    // Direct MSB output
    assign dout = data[3];

endmodule