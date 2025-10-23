module multi_16bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] ain,
    input  wire [15:0] bin,
    output wire [31:0] yout,
    output wire        done
);

    typedef enum logic [1:0] {IDLE=2'd0, LOAD=2'd1, CALC=2'd2, DONE=2'd3} state_t;
    state_t state, next_state;

    reg [4:0] count;            // counts from 0 to 16
    reg [31:0] product;         // 32-bit product register (accumulator)
    reg [15:0] multiplier;      // 16-bit multiplier register
    reg [15:0] multiplicand;    // 16-bit multiplicand register

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = start ? LOAD : IDLE;
            LOAD:  next_state = CALC;
            CALC:  next_state = (count == 5'd16) ? DONE : CALC;
            DONE:  next_state = start ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product     <= 32'd0;
            multiplicand<= 16'd0;
            multiplier  <= 16'd0;
            count       <= 5'd0;
        end else begin
            case(state)
                IDLE: begin
                    product     <= 32'd0;
                    count       <= 5'd0;
                end
                LOAD: begin
                    multiplicand<= ain;
                    multiplier  <= bin;
                    product     <= 32'd0;
                    count       <= 5'd0;
                end
                CALC: begin
                    // If LSB of multiplicand is 1, add multiplier shifted by count to product
                    if (multiplicand[0])
                        product <= product + ( {16'd0, multiplier} << count );
                    // Shift multiplicand right by 1 to process next bit next cycle
                    multiplicand <= multiplicand >> 1;
                    count <= count + 1;
                end
                DONE: begin
                    // Hold values until start asserted
                end
            endcase
        end
    end

    assign yout = product;
    assign done = (state == DONE);

endmodule