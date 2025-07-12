// A novel 8-bit 2-to-1 multiplexer implementation using a state machine
module TopModule (
    // Select line input
    input        sel,
    // 8-bit input a
    input  [7:0] a,
    // 8-bit input b
    input  [7:0] b,
    // 8-bit output selected based on sel
    output [7:0] out
);

    // Internal state variable to track the current selection
    reg [7:0] state;

    // Initialize the state variable
    initial state = a;

    // Always block to handle state transitions and output assignment
    always @(posedge sel) begin
        // If sel is high, transition to select 'b'
        if (sel) begin
            state = b;
        end
        // If sel is low, transition to select 'a'
        else begin
            state = a;
        end
    end

    // Assign the output based on the current state
    assign out = state;

endmodule