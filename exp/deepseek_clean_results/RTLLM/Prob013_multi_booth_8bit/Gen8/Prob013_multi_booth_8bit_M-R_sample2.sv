module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        CALC,
        DONE
    } state_t;
    
    state_t state;
    
    // Internal registers
    reg [15:0] A_reg;    // Multiplicand (sign extended)
    reg [15:0] S_reg;    // Negative multiplicand (sign extended)
    reg [16:0] P_reg;    // Product accumulator (extra bit for sign)
    reg [1:0] counter;   // Iteration counter (0-3 for 8 bits)
    
    // Booth encoding bits
    wire [2:0] booth_bits = {P_reg[1:0], (counter == 0) ? 1'b0 : P_reg[2]};
    
    // Booth selection logic
    wire [15:0] booth_select;
    assign booth_select = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? A_reg :
        (booth_bits == 3'b011) ? (A_reg << 1) :
        (booth_bits == 3'b100) ? (S_reg << 1) :
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? S_reg : 16'b0;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            A_reg <= {{8{a[7]}}, a};
            S_reg <= -{{8{a[7]}}, a};
            P_reg <= {8'b0, b, 1'b0};
            counter <= 2'b0;
            rdy <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start calculation
                    p <= 16'b0;
                    rdy <= 1'b0;
                    state <= CALC;
                end
                
                CALC: begin
                    // Accumulate Booth result
                    P_reg <= {P_reg[16], P_reg[16:2]} + {booth_select[15], booth_select};
                    
                    // Shift P_reg right by 2 bits (Radix-4)
                    P_reg[15:0] <= {P_reg[16:2]};
                    
                    // Update counter
                    if (counter == 2'd3) begin
                        state <= DONE;
                    end
                    counter <= counter + 1;
                end
                
                DONE: begin
                    // Final result
                    p <= P_reg[16:1];
                    rdy <= 1'b1;
                    state <= DONE;
                end
            endcase
        end
    end

endmodule