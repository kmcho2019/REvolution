module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output [31:0]   yout,
    output          done
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg         state, next_state;
    reg [4:0]   count;          // Counts 0 to 16
    reg [31:0]  product;        // Partial product + multiplier bits
    reg [31:0]  multiplicand;   // Multiplicand extended to 32-bit for addition

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? BUSY : IDLE;
            BUSY: next_state = (count == 5'd16) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // State and count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
        end else begin
            state <= next_state;
            if (state == IDLE && start)
                count <= 5'd0;
            else if (state == BUSY)
                count <= count + 5'd1;
            else
                count <= 5'd0;
        end
    end

    // Load multiplicand and product registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 32'd0;
            product <= 32'd0;
        end else if (state == IDLE) begin
            if (start) begin
                multiplicand <= {16'd0, ain}; // Left aligned for addition
                product <= {16'd0, bin};      // Multiplier in LSB half
            end else begin
                multiplicand <= 32'd0;
                product <= 32'd0;
            end
        end else if (state == BUSY) begin
            // If LSB of product is 1, add multiplicand to upper half of product before shifting
            if (product[0]) begin
                // Add multiplicand shifted by 0 (already aligned) to the high 32-bit product upper half
                // Actually product is 32-bit: upper half is bits [31:16], lower half [15:0] is multiplier bits shifting out
                // Addition affects bits [31:16], but we add directly to product, then shift right.
                product <= (product + multiplicand) >> 1;
            end else begin
                // Just shift right by 1 with zero fill
                product <= product >> 1;
            end
        end
    end

    assign done = (state == BUSY) && (count == 5'd16);
    assign yout = product;

endmodule