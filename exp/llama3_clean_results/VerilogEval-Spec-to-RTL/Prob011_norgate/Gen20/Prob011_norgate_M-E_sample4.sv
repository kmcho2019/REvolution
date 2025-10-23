// Module for a NOR gate implemented using a finite state machine (FSM)
module NorGateFSM(
    input  logic clk,  // Clock signal
    input  logic a,   // Input signal a
    input  logic b,   // Input signal b
    output logic out   // Output signal out
);
    // Define the states
    enum logic [1:0] {IDLE, OUTPUT} state, next_state;
    
    // Initialize the state
    initial state = IDLE;
    
    // Sequential logic for state transitions
    always_ff @(posedge clk) begin
        state <= next_state;
    end
    
    // Combinational logic for next state and output
    always_comb begin
        case(state)
            IDLE: begin
                if (~a & ~b) begin
                    next_state = OUTPUT;
                end else begin
                    next_state = IDLE;
                end
                out = 0;  // Default output in IDLE state
            end
            OUTPUT: begin
                next_state = IDLE;  // Automatically transition back to IDLE
                out = 1;  // Set output to 1 in OUTPUT state
            end
        endcase
    end
endmodule

// Testbench for the NorGateFSM module
module Testbench;
    logic clk, a, b, out;
    
    NorGateFSM nor_gate_fsm_instance(
        .clk(clk),
        .a(a),
        .b(b),
        .out(out)
    );
    
    initial begin
        // Initialize inputs
        clk = 0;
        a = 0;
        b = 0;
        
        // Test the NOR gate
        forever begin
            #10;  // Wait for 10 time units
            clk = ~clk;  // Toggle the clock
            
            // Test all input combinations
            if (clk) begin
                #5;
                a = $random_range(0, 1);
                b = $random_range(0, 1);
            end
        end
    end
endmodule