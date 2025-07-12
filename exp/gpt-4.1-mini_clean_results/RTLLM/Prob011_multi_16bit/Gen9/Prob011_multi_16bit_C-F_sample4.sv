module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   i;           // shift count: 0 idle, 1-16 active, 17 done clear
    reg [15:0]  areg;        // multiplicand
    reg [31:0]  product;     // {partial sum (upper 16 bits), multiplier bits (lower 16 bits)}
    reg         done_r;

    wire active = (i > 0) && (i <= 16);
    wire cnt_enable = start && (i < 5'd17);
    wire load_inputs = start && (i == 5'd0);
    wire done_set = (i == 5'd16);

    // Shift count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (cnt_enable) begin
            i <= i + 5'd1;
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (!start) begin
            done_r <= 1'b0;
        end else if (done_set) begin
            done_r <= 1'b1;
        end
    end

    // Datapath operation: load inputs, then shift and accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            product <= 32'd0;
        end else if (!start) begin
            areg    <= 16'd0;
            product <= 32'd0;
        end else if (load_inputs) begin
            areg    <= ain;
            product <= {16'd0, bin};
        end else if (active) begin
            // If LSB of product is 1, add multiplicand shifted by 16 to upper half, then shift right
            if (product[0])
                product <= ((product + {areg, 16'd0}) >> 1);
            else
                product <= (product >> 1);
        end
        // else hold current values implicitly
    end

    assign yout = product;
    assign done = done_r;

endmodule