module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state;
    wire [5:0] next_state;

    // Next state logic - each bit assigned separately
    assign next_state[0] = ~reset & ((current_state == A & ~w) | 
                                   (current_state == D & ~w));
    
    assign next_state[1] = ~reset & ((current_state == A & w) | 
                                   (current_state == F & w));
    
    assign next_state[2] = ~reset & ((current_state == B & w) | 
                                   (current_state == F & ~w) | 
                                   (current_state == D & w));
    
    assign next_state[3] = ~reset & ((current_state == B & ~w) | 
                                   (current_state == C & ~w) | 
                                   (current_state == D & ~w) | 
                                   (current_state == E & ~w));
    
    assign next_state[4] = ~reset & ((current_state == C & w) | 
                                   (current_state == E & w));
    
    assign next_state[5] = ~reset & (current_state == D & w);

    // State storage with synchronous reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output is OR of states E and F (bits 4 and 5)
    assign z = current_state[4] | current_state[5];

endmodule