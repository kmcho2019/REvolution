module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State machine
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;
    
    reg [1:0] state;
    reg [3:0] count;
    reg [15:0] multiplicand;
    reg [16:0] multiplier;  // Extended by 1 bit for Booth encoding
    
    // Carry-save registers
    reg [31:0] sum;
    reg [31:0] carry;
    
    // Booth encoding signals
    wire [2:0] booth_bits;
    wire [16:0] pp;  // Partial product
    wire neg_pp;
    
    // Control signals
    wire last_iteration = (count == 4'd8);
    wire early_term = (multiplier[16:1] == 16'b0) && (state == CALC);
    
    // Booth encoder
    assign booth_bits = multiplier[2:0];
    assign neg_pp = (booth_bits == 3'b100) || (booth_bits == 3'b101) || 
                   (booth_bits == 3'b110);
    
    // Partial product generator
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: pp = 17'b0;
            3'b001, 3'b010: pp = {1'b0, multiplicand};
            3'b011: pp = multiplicand << 1;
            3'b100: pp = ~({1'b0, multiplicand}) + 1'b1;
            3'b101, 3'b110: pp = ~(multiplicand << 1) + 1'b1;
            default: pp = 17'b0;
        endcase
    end
    
    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'b0;
            multiplicand <= 16'b0;
            multiplier <= 17'b0;
            sum <= 32'b0;
            carry <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                        sum <= 32'b0;
                        carry <= 32'b0;
                    end
                end
                
                LOAD: begin
                    multiplicand <= ain;
                    multiplier <= {bin, 1'b0};  // Append 0 for Booth encoding
                    count <= 4'b0;
                    state <= CALC;
                end
                
                CALC: begin
                    if (early_term || last_iteration) begin
                        state <= DONE;
                        // Final adder (sum + carry)
                        yout <= sum + carry;
                        done <= 1'b1;
                    end else begin
                        // Carry-save addition
                        {carry, sum} <= {sum[30:0], 1'b0} + 
                                        {carry[30:0], 1'b0} + 
                                        {{15{pp[16]}}, pp};
                        multiplier <= multiplier >> 2;
                        count <= count + 1;
                    end
                end
                
                DONE: begin
                    if (!start) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule