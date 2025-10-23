module multi_16bit (
    input          clk,
    input          rst_n,    // active-low synchronous reset
    input          start,
    input  [15:0]  ain,      // multiplicand
    input  [15:0]  bin,      // multiplier
    output [31:0]  yout,
    output         done
);

    // State definition: IDLE or MULTIPLY
    localparam IDLE     = 1'b0;
    localparam MULTIPLY = 1'b1;

    reg          state, next_state;
    reg [4:0]    count;      // multiplication cycle counter 0..16
    reg [15:0]   multiplicand;
    reg [31:0]   product;
    
    // Next state logic
    always @(*) begin
        case(state)
            IDLE:
                if (start) 
                    next_state = MULTIPLY;
                else
                    next_state = IDLE;
            MULTIPLY:
                if (count == 5'd16)
                    next_state = IDLE;
                else
                    next_state = MULTIPLY;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            count         <= 5'd0;
            multiplicand  <= 16'd0;
            product       <= 32'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                count <= 5'd0;
                if (start) begin
                    multiplicand <= ain;
                    // Place multiplier in lower 16 bits of product register, upper 16 bits cleared
                    product <= {16'd0, bin};
                end
            end else if (state == MULTIPLY) begin
                count <= count + 5'd1;

                // If LSB of product is 1, add multiplicand shifted by count-1 to upper bits of product
                // Actually, adding multiplicand shifted by count-1 to upper 16 bits of product
                if (product[0]) begin
                    // Add multiplicand shifted by count-1 to product[31:16]
                    // product[31:0] = product + (multiplicand << (count-1))
                    // This is achieved by adding multiplicand shifted left count-1 to product shifted right 1 (because of shift)
                    // But simpler to perform product = product + (multiplicand << (count-1)) before shifting
                    product <= (product + (multiplicand << (count - 1))) >> 1;
                end else begin
                    // Just shift product right by 1
                    product <= product >> 1;
                end
            end
        end
    end

    assign yout = product;
    assign done = (state == MULTIPLY) && (count == 5'd16);

endmodule