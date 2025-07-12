module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    // State encoding using enumerated localparams
    localparam IDLE = 2'd0;
    localparam LOAD = 2'd1;
    localparam CALC = 2'd2;

    reg [1:0] state, next_state;
    reg [4:0] count;         // shift count: 0 to 16
    reg [15:0] multiplicand;
    reg [31:0] product;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 5'd16) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and counter update
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
        end else begin
            state <= next_state;
            if(state == LOAD)
                count <= 5'd0;
            else if(state == CALC)
                count <= count + 5'd1;
            else
                count <= 5'd0;
        end
    end

    // Registers update: multiplicand and product
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            multiplicand <= 16'd0;
            product <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done to 0, asserted below if needed
            case(state)
                IDLE: begin
                    // outputs held or cleared
                    yout <= yout;
                end
                LOAD: begin
                    multiplicand <= ain;
                    product <= {16'd0, bin}; // load multiplier into lower half, clear upper half
                end
                CALC: begin
                    // Shift and accumulate step:
                    // If LSB of product is 1, add multiplicand shifted to upper half
                    if(product[0])
                        product <= (product >> 1) + ({multiplicand,16'd0} >> 1);
                    else
                        product <= product >> 1;
                    if(count == 5'd16) begin
                        yout <= product;
                        done <= 1'b1;
                    end
                end
                default: begin
                    multiplicand <= 16'd0;
                    product <= 32'd0;
                    yout <= 32'd0;
                end
            endcase
        end
    end

endmodule