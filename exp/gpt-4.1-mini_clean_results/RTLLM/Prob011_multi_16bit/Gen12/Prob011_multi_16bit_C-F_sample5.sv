module multi_16bit (
    input          clk,
    input          rst_n,    // active-low synchronous reset
    input          start,    // start signal to begin multiplication
    input  [15:0]  ain,      // multiplicand
    input  [15:0]  bin,      // multiplier
    output [31:0]  yout,     // product output
    output         done      // done flag
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg         state, next_state;
    reg [4:0]   count;           // counts 0 to 16
    reg [31:0]  product;         // partial product + shifted multiplier
    reg [15:0]  multiplicand;   // holds multiplicand input
    reg         done_r;

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? BUSY : IDLE;
            BUSY: next_state = (count == 5'd16) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // FSM state and counter update with synchronous reset
    always @(posedge clk) begin
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

    // Load multiplicand on start
    always @(posedge clk) begin
        if (!rst_n)
            multiplicand <= 16'd0;
        else if (state == IDLE && start)
            multiplicand <= ain;
        else
            multiplicand <= multiplicand; // hold
    end

    // Load multiplier into product low half on start, clear upper half
    // Then during BUSY shift right and conditionally add multiplicand shifted
    always @(posedge clk) begin
        if (!rst_n) begin
            product <= 32'd0;
        end else if (state == IDLE) begin
            if (start)
                product <= {16'd0, bin};  // multiplier in low 16 bits, upper 16 zero
            else
                product <= product;        // hold previous
        end else if (state == BUSY) begin
            // Check LSB to decide add
            if (product[0] == 1'b1) begin
                // Shift right 1 and add multiplicand shifted left by count (equiv: product>>1 + multiplicand<<15)
                // Since shifting product right 1, we add multiplicand shifted left by 15 bits after shifting product
                // To avoid large shifter, perform: product = (product >> 1) + (multiplicand << 15)
                // But need to add multiplicand shifted left by count-1 (done implicitly by shifting product right each cycle)
                // Actually this is classical shift-add multiplication shifting right product by 1 each cycle
                // And adding multiplicand shifted by count at each cycle.
                // We can add multiplicand shifted left by 15 (equivalent to multiplicand << (count-1)) because the multiplier bits shift into product LSB.
                // But to avoid complex shifting multiplicand, we use multiplicand << 15 as an offset and product shifting emulates count.
                // Alternatively, we can keep multiplicand fixed and simply add (multiplicand << 15) each time LSB==1, because product shifts right each cycle.
                // This method works because product contains multiplier and partial sum.
                // Hence, implement as: product <= (product >> 1) + (multiplicand << 15);
                product <= (product >> 1) + (multiplicand << 15);
            end else begin
                // Just shift product right by 1
                product <= product >> 1;
            end
        end else begin
            product <= product; // hold
        end
    end

    // done flag generation: asserted one cycle at count == 16 in BUSY
    always @(posedge clk) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (state == BUSY && count == 5'd16)
            done_r <= 1'b1;
        else
            done_r <= 1'b0;
    end

    assign yout = product;
    assign done = done_r;

endmodule