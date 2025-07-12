module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] shift_reg;
    reg [2:0] cnt; // counts from 0 to 3 for 4 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'd0;
            cnt       <= 3'd4; // set to 4 to trigger load at first cycle
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 3'd4) begin
                // Load new data into shift register
                shift_reg <= d;
                cnt       <= 3'd0;
                valid_out <= 1'b1;
                dout      <= d[3]; // MSB first
            end else begin
                // Output current MSB, shift left to get next bit at MSB
                valid_out <= 1'b1;
                dout      <= shift_reg[3];
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt       <= cnt + 1;
            end
        end
    end

endmodule