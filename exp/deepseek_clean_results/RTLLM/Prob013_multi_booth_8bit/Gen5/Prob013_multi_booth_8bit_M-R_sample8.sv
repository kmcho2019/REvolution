module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    typedef enum {IDLE, CALCULATE, DONE} state_t;
    reg [1:0] state;
    reg [2:0] counter;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;
    
    // Combinational outputs
    assign rdy = (state == DONE);
    
    // Booth encoding and partial product selection (combinational)
    wire [15:0] partial_product;
    assign partial_product = 
        ({multiplier[1:0], prev_lsb} == 3'b001 || 
         {multiplier[1:0], prev_lsb} == 3'b010) ? multiplicand :
        ({multiplier[1:0], prev_lsb} == 3'b011) ? {multiplicand[14:0], 1'b0} :
        ({multiplier[1:0], prev_lsb} == 3'b100) ? -{multiplicand[14:0], 1'b0} :
        ({multiplier[1:0], prev_lsb} == 3'b101 || 
         {multiplier[1:0], prev_lsb} == 3'b110) ? -multiplicand :
        16'b0;
    
    // Main state machine and datapath
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            counter <= 3'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            prev_lsb <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALCULATE;
                    p <= 16'b0;
                    counter <= 3'b0;
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    prev_lsb <= 1'b0;
                end
                
                CALCULATE: begin
                    p <= p + (partial_product << (counter * 2));
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                    counter <= counter + 1;
                    
                    if (counter == 3'd3) begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule