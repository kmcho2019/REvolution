module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State machine definitions
    typedef enum {IDLE, COMPUTE, DONE} state_t;
    reg [1:0] state, next_state;
    
    // Data path registers
    reg [15:0] mcand;
    reg [15:0] partial_prod;
    reg [8:0] mplier;  // Extended to handle shift out
    reg [1:0] counter;
    
    // Combinational signals
    wire [2:0] booth_bits;
    wire [15:0] mcand_x2;
    wire [15:0] next_partial;
    wire zero_operand;
    
    // Continuous assignments
    assign mcand_x2 = mcand << 1;
    assign booth_bits = mplier[2:0];
    assign zero_operand = (a == 8'b0) | (b == 8'b0);
    
    // Booth encoding combinational logic
    assign next_partial = 
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? partial_prod + mcand :
        (booth_bits == 3'b011) ? partial_prod + mcand_x2 :
        (booth_bits == 3'b100) ? partial_prod - mcand_x2 :
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? partial_prod - mcand :
        partial_prod;
    
    // State machine
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = reset ? IDLE : COMPUTE;
            COMPUTE: next_state = (counter == 2'b11) ? DONE : COMPUTE;
            DONE:    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end
    
    // Data path registers
    always @(posedge clk) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};
            mplier <= {b, 1'b0};
            partial_prod <= 16'b0;
            counter <= 2'b0;
        end
        else if (state == COMPUTE) begin
            partial_prod <= next_partial;
            mcand <= mcand << 2;
            mplier <= mplier >> 2;
            counter <= counter + 1;
        end
    end
    
    // Output registers
    always @(posedge clk) begin
        if (reset) begin
            p <= 16'b0;
            rdy <= zero_operand;
        end
        else if (state == COMPUTE && counter == 2'b11) begin
            p <= next_partial;
            rdy <= 1'b1;
        end
    end

endmodule