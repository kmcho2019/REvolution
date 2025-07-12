module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Gray code state encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state;
    reg [2:0] next_state;
    
    // ROM for state transitions [current_state][w] -> next_state
    reg [2:0] state_rom [0:11]; // 6 states * 2 inputs = 12 entries
    
    // Initialize ROM contents
    integer i;
    initial begin
        // Format: state_rom[{current_state,w}] = next_state
        state_rom[{A,1'b0}] = A;
        state_rom[{A,1'b1}] = B;
        state_rom[{B,1'b0}] = D;
        state_rom[{B,1'b1}] = C;
        state_rom[{C,1'b0}] = D;
        state_rom[{C,1'b1}] = E;
        state_rom[{D,1'b0}] = A;
        state_rom[{D,1'b1}] = F;
        state_rom[{E,1'b0}] = D;
        state_rom[{E,1'b1}] = E;
        state_rom[{F,1'b0}] = D;
        state_rom[{F,1'b1}] = C;
    end

    // State transition logic using ROM lookup
    always @(*) begin
        next_state = state_rom[{current_state,w}];
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // Registered output (z is high in states E or F)
            z <= (next_state == E) | (next_state == F);
        end
    end

endmodule