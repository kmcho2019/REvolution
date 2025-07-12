module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic using ternary operators
    assign next_state = reset ? 3'b000 : 
                       (state == 3'b000) ? (x ? 3'b001 : 3'b000) :
                       (state == 3'b001) ? (x ? 3'b100 : 3'b001) :
                       (state == 3'b010) ? (x ? 3'b001 : 3'b010) :
                       (state == 3'b011) ? (x ? 3'b010 : 3'b001) :
                       (state == 3'b100) ? (x ? 3'b100 : 3'b011) :
                       3'b000;  // Default case (should never occur)

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic - 1 when state is 011 or 100
    assign z = (state[2:0] == 3'b011) | (state[2:0] == 3'b100);

endmodule