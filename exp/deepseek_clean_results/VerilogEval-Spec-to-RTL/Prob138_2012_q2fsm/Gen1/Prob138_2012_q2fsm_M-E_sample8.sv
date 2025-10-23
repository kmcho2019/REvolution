module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001;
    localparam [5:0] B = 6'b000010;
    localparam [5:0] C = 6'b000100;
    localparam [5:0] D = 6'b001000;
    localparam [5:0] E = 6'b010000;
    localparam [5:0] F = 6'b100000;

    reg [5:0] current_state;
    wire [5:0] next_state;

    // ROM-based transition table (state + w -> next_state)
    // Index is {current_state, w} (6+1 = 7 bits)
    reg [5:0] transition_rom [0:127];
    
    initial begin
        // Initialize ROM
        // Format: transition_rom[{state, w}] = next_state
        transition_rom[{A, 1'b0}] = A;
        transition_rom[{A, 1'b1}] = B;
        transition_rom[{B, 1'b0}] = D;
        transition_rom[{B, 1'b1}] = C;
        transition_rom[{C, 1'b0}] = D;
        transition_rom[{C, 1'b1}] = E;
        transition_rom[{D, 1'b0}] = A;
        transition_rom[{D, 1'b1}] = F;
        transition_rom[{E, 1'b0}] = D;
        transition_rom[{E, 1'b1}] = E;
        transition_rom[{F, 1'b0}] = D;
        transition_rom[{F, 1'b1}] = C;
    end

    // Next state lookup
    assign next_state = transition_rom[{current_state, w}];

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z is 1 for states E and F (bits 4 and 5)
    assign z = current_state[4] | current_state[5];

endmodule