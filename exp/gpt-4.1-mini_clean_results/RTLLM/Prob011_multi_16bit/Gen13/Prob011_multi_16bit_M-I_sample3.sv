module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0] count;         // Shift counter: 0..16
    reg [15:0] multiplicand;
    reg [31:0] product;
    wire update_en;

    // Control count register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd0;
        else if (start)
            count <= (count < 5'd17) ? count + 5'd1 : 5'd17;
        else
            count <= 5'd0;
    end

    // Load multiplicand at count==0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            multiplicand <= 16'd0;
        else if (count == 5'd0 && start)
            multiplicand <= ain;
    end

    // Load multiplier into product lower half at count==0
    // Clear upper half of product at start
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product <= 32'd0;
        else if (count == 5'd0 && start)
            product <= {16'd0, bin};
        else if (update_en) begin
            if (product[0])
                product <= (product >> 1) + ({multiplicand,16'd0} >> 1);
            else
                product <= product >> 1;
        end
    end

    // Enable product update only during active multiply cycles (1 to 16)
    // and only when count in 1..16 to match shift counts
    assign update_en = (count >= 5'd1 && count <= 5'd16);

    // done when count reaches 16 (one cycle after last shift)
    assign done = (count == 5'd16);

    assign yout = product;

endmodule