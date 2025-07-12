module TopModule (
    input clk,
    input x,
    input [2:0] y,  // Note: y input is unused in this correct implementation
    output Y0,
    output z
);

    reg [2:0] current_state = 3'b000;  // Initialize to state 000
    wire [2:0] next_state;

    // Next state logic using continuous assignments
    assign next_state = 
        (current_state == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (current_state == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (current_state == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (current_state == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (current_state == 3'b100) ? (x ? 3'b100 : 3'b011) :
        3'b000;  // default case

    // Output logic
    assign z = (current_state == 3'b011) || (current_state == 3'b100);
    assign Y0 = next_state[0];

    // State update
    always @(posedge clk) begin
        current_state <= next_state;
    end

endmodule