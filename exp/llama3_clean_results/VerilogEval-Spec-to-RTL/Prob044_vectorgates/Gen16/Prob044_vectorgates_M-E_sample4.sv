// Module for shared operation (bitwise-OR and logical-OR)
module SharedOperation(
    input  [2:0] a,
    input  [2:0] b,
    input  op_select, // 0 for bitwise-OR, 1 for logical-OR
    output [2:0] out_or_bitwise,
    output out_or_logical
);
    assign out_or_bitwise = a | b;
    assign out_or_logical = (|a) || (|b);
endmodule

// Finite State Machine (FSM) module
module FSM(
    input  clk, // Clock signal
    input  rst_n, // Active low reset
    output [2:0] out_not, // Output for NOT operation
    output [2:0] out_or_bitwise, // Output for bitwise-OR operation
    output out_or_logical // Output for logical-OR operation
);
    reg [1:0] state; // FSM state register
    reg [2:0] a; // Input vector a
    reg [2:0] b; // Input vector b
    reg [2:0] not_a; // Inverted vector a
    reg [2:0] not_b; // Inverted vector b

    // FSM state transitions
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00; // Reset state
        end else begin
            case (state)
                2'b00: begin // Initial state
                    state <= 2'b01; // Transition to bitwise-OR state
                end
                2'b01: begin // Bitwise-OR state
                    state <= 2'b10; // Transition to logical-OR state
                end
                2'b10: begin // Logical-OR state
                    state <= 2'b11; // Transition to NOT operation state
                end
                2'b11: begin // NOT operation state
                    state <= 2'b00; // Loop back to initial state
                end
                default: begin
                    state <= 2'b00; // Default to initial state
                end
            endcase
        end
    end

    // FSM output logic
    always @(posedge clk) begin
        case (state)
            2'b00: begin // Initial state
                // Load input vectors
                a <= 3'b000; // Example input vector a
                b <= 3'b000; // Example input vector b
            end
            2'b01: begin // Bitwise-OR state
                // Perform bitwise-OR operation
                out_or_bitwise <= a | b;
            end
            2'b10: begin // Logical-OR state
                // Perform logical-OR operation
                out_or_logical <= (|a) || (|b);
            end
            2'b11: begin // NOT operation state
                // Perform NOT operation
                not_a <= ~a;
                not_b <= ~b;
                out_not <= {not_b, not_a}; // Combine inverted vectors
            end
            default: begin
                // Default output values
                out_or_bitwise <= 3'b000;
                out_or_logical <= 1'b0;
                out_not <= 6'b000000;
            end
        endcase
    end
endmodule

// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    FSM u_fsm(
       .clk(clk), // Assume a clock signal is available
       .rst_n(rst_n), // Assume an active low reset signal is available
       .out_not(out_not[5:0]),
       .out_or_bitwise(out_or_bitwise),
       .out_or_logical(out_or_logical)
    );
endmodule