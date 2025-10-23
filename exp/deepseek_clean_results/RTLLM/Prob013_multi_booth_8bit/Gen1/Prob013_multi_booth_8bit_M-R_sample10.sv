module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // FSM states
    typedef enum {IDLE, COMPUTE, DONE} state_t;
    state_t current_state, next_state;

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [1:0] ctr;
    reg prev_bit;  // Stores previous bit for Booth encoding

    // Booth encoding outputs
    wire add, sub, add2, sub2;
    wire [15:0] multiplicand_x2 = multiplicand << 1;

    // Booth encoding logic (combinational)
    assign {add, sub, add2, sub2} = 
        (multiplier[1:0] == 2'b00 && prev_bit == 1'b0) ? 4'b0000 : // No op
        (multiplier[1:0] == 2'b00 && prev_bit == 1'b1) ? 4'b0100 : // +M
        (multiplier[1:0] == 2'b01 && prev_bit == 1'b0) ? 4'b1000 : // +M
        (multiplier[1:0] == 2'b01 && prev_bit == 1'b1) ? 4'b0010 : // +2M
        (multiplier[1:0] == 2'b10 && prev_bit == 1'b0) ? 4'b0001 : // -2M
        (multiplier[1:0] == 2'b10 && prev_bit == 1'b1) ? 4'b0100 : // -M
        (multiplier[1:0] == 2'b11 && prev_bit == 1'b0) ? 4'b1000 : // -M
        4'b0000;                                                   // No op

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    next_state <= COMPUTE;
                end
                
                COMPUTE: begin
                    // Perform Booth operation
                    if (add)  p <= p + multiplicand;
                    if (sub)  p <= p - multiplicand;
                    if (add2) p <= p + multiplicand_x2;
                    if (sub2) p <= p - multiplicand_x2;
                    
                    // Update registers
                    multiplier <= multiplier >> 2;
                    prev_bit <= multiplier[1];
                    ctr <= ctr + 1;
                    
                    if (ctr == 3) next_state <= DONE;
                    else next_state <= COMPUTE;
                end
                
                DONE: begin
                    rdy <= 1'b1;
                    next_state <= DONE;
                end
            endcase
        end
    end

endmodule