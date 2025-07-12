module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [1:0] cnt;
    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            shift_reg <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                shift_reg <= d;            // Load parallel data
                valid_out <= 1'b1;         // Valid high during serialization
                dout      <= d[3];         // Output MSB first
                cnt       <= cnt + 1'b1;
            end else begin
                shift_reg <= shift_reg >> 1; // Shift right by 1 bit
                dout      <= shift_reg[2];    // Next MSB is bit 2 after shift
                valid_out <= 1'b1;            // Valid asserted all cycles of serialization
                if (cnt == 2'd3)
                    cnt <= 2'd0;
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule