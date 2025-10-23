module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);
    reg [4:0]   count;         // counts from 0 to 16
    reg [31:0]  product;       // upper 16 bits accumulator, lower 16 bits multiplier
    reg         done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 5'd0;
            product <= 32'd0;
            done_r  <= 1'b0;
        end else begin
            if (start) begin
                count   <= 5'd0;
                product <= {16'd0, bin}; // Load multiplier into lower bits
                done_r  <= 1'b0;
            end else if (count < 16) begin
                // If LSB is 1, add multiplicand shifted to upper 16 bits
                if (product[0])
                    product[31:16] <= product[31:16] + ain;
                // Shift right by 1 bit: shift accumulator and multiplier together
                product <= {1'b0, product[31:1]};
                count <= count + 5'd1;
                done_r <= 1'b0;
            end else if (count == 16) begin
                done_r <= 1'b1;  // done asserted after 16 cycles
                count <= 5'd17;  // Move to done state
            end else begin
                done_r <= 1'b0;  // Clear done after done cycle
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule