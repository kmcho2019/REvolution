module TopModule(
    input clk,
    input reset,
    input x,
    output z
);
    reg [2:0] y;
    wire [2:0] y_next;

    // Combinational next state logic using continuous assignments
    // Decode each next state bit from present state y and input x
    assign y_next = 
        (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
        3'b000;

    // Synchronous state register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            y <= 3'b000;
        else
            y <= y_next;
    end

    // Optimized output logic using combinational expression from state bits
    assign z = (y[2] & ~y[1] & ~y[0]) | (~y[2] & y[1] & y[0]);

endmodule