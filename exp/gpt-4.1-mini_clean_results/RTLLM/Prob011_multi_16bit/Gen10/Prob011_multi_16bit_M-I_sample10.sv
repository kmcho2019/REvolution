module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg         state, next_state;
    reg [4:0]   count;        // 0 to 16
    reg [31:0]  product;      // accumulator holds partial product and multiplier
    reg [15:0]  multiplicand;

    wire        product_lsb = product[0];
    wire        en_shift_add;

    // Enable update when BUSY and shifting needed
    assign en_shift_add = (state == BUSY);

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = BUSY;
                else
                    next_state = IDLE;
            end
            BUSY: begin
                if (count == 5'd16)
                    next_state = IDLE;
                else
                    next_state = BUSY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and counter update
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

    // Multiplicand register load
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            multiplicand <= 16'd0;
        else if (state == IDLE && start)
            multiplicand <= ain;
    end

    // Product register update with clock enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 32'd0;
        end else if (state == IDLE) begin
            if (start)
                product <= {16'd0, bin}; // load multiplier in LSB half, zero upper half
            else
                product <= 32'd0;
        end else if (state == BUSY) begin
            // Update product only if enabled (always in BUSY)
            // Add shifted multiplicand if LSB == 1, else only shift right
            if (product_lsb)
                product <= (product >> 1) + ({multiplicand,16'd0} >> 1);
            else
                product <= product >> 1;
        end
    end

    // done flag asserted when BUSY state and count reaches 16
    assign done = (state == BUSY) && (count == 5'd16);

    // final product output
    assign yout = product;

endmodule