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
    reg [4:0]   count;        // Counts 0 to 16
    reg [31:0]  product;      // Holds partial product and multiplier
    reg [15:0]  multiplicand;

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? BUSY : IDLE;
            BUSY: next_state = (count == 5'd16) ? IDLE : BUSY;
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

    // Multiplicand register load (latched on start)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            multiplicand <= 16'd0;
        else if (state == IDLE && start)
            multiplicand <= ain;
    end

    // Product register update: Shift right and add shifted multiplicand when product[0] is 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 32'd0;
        end else if (state == IDLE) begin
            if (start)
                product <= {16'd0, bin}; // Load multiplier in lower half, zero upper half
            else
                product <= 32'd0;
        end else if (state == BUSY) begin
            // Shift right by 1 first
            product <= (product[0]) ? ((product >> 1) + ({multiplicand,16'd0} >> 1)) : (product >> 1);
        end
    end

    assign done = (state == BUSY) && (count == 5'd16);
    assign yout = product;

endmodule