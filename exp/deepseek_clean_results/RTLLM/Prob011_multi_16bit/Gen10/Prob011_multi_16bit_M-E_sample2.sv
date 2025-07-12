module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Booth encoding parameters
    localparam IDLE = 3'b000;
    localparam BOOTH = 3'b001;
    localparam CSA = 3'b011;
    localparam FINAL = 3'b010;
    localparam DONE = 3'b110;

    reg [2:0] state, next_state; // Gray coded
    reg [3:0] count;
    reg [15:0] multiplicand;
    reg [16:0] multiplier; // Extra bit for Booth
    reg zero_case;
    
    // Partial products and carry-save registers
    reg [31:0] partial_products [8:0];
    reg [31:0] sum [3:0];
    reg [31:0] carry [3:0];
    reg [31:0] final_sum, final_carry;

    // Booth encoder
    always @(*) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            case (multiplier[2*i+1:2*i-1])
                3'b000, 3'b111: partial_products[i] = 32'b0;
                3'b001, 3'b010: partial_products[i] = {16'b0, multiplicand} << (2*i);
                3'b011: partial_products[i] = {15'b0, multiplicand, 1'b0} << (2*i);
                3'b100: partial_products[i] = ~({15'b0, multiplicand, 1'b0} << (2*i)) + 1;
                3'b101, 3'b110: partial_products[i] = ~({16'b0, multiplicand} << (2*i)) + 1;
            endcase
        end
        partial_products[8] = multiplier[16] ? ~{16'b0, multiplicand} + 1 : 32'b0;
    end

    // Carry-save adder tree
    always @(*) begin
        // First level
        {carry[0], sum[0]} = partial_products[0] + partial_products[1] + partial_products[2];
        {carry[1], sum[1]} = partial_products[3] + partial_products[4] + partial_products[5];
        {carry[2], sum[2]} = partial_products[6] + partial_products[7] + partial_products[8];
        
        // Second level
        {carry[3], sum[3]} = sum[0] + carry[0] + sum[1];
        
        // Final addition
        final_sum = sum[3] + carry[3] + sum[2];
        final_carry = carry[1] + carry[2];
    end

    // State machine (gray coded)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 0;
            done <= 0;
            yout <= 0;
            zero_case <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= {bin, 1'b0}; // For Booth
                        zero_case <= (bin == 0);
                    end
                end
                
                BOOTH: begin
                    // Booth encoding happens in combinational logic
                end
                
                CSA: begin
                    // Carry-save addition happens in combinational logic
                end
                
                FINAL: begin
                    yout <= final_sum + final_carry;
                end
                
                DONE: begin
                    done <= 1;
                    if (zero_case) yout <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? BOOTH : IDLE;
            BOOTH: next_state = CSA;
            CSA: next_state = FINAL;
            FINAL: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule