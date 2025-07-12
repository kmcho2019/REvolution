module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Output the bit at position cnt from the registered data (MSB at cnt=3 down to LSB at cnt=0)
    assign dout = data_reg[cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd3;
            valid_out <= 1'b0;
            data_reg  <= 4'd0;
        end else begin
            if (cnt == 2'd0) begin
                // Last bit output, prepare new data, reset counter
                cnt       <= 2'd3;
                data_reg  <= d;       // Latch parallel input at this moment to reduce glitches on dout
                valid_out <= 1'b1;    // Assert valid_out indicating MSB was just output (start of new sequence)
            end else begin
                cnt       <= cnt - 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule