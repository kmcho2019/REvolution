module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next state logic
    assign next_state = 
        (state == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (state == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (state == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (state == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (state == 3'b100) ? (x ? 3'b100 : 3'b011) :
        3'b000; // Default case (should never occur)

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic
    assign z = (state == 3'b011) || (state == 3'b100);

endmodule