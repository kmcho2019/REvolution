module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding (direct binary representation)
    reg [1:0] state;

    // Next state logic using continuous assignments
    wire [1:0] next_state = 
        (state == 2'b00) ? (in ? 2'b01 : 2'b00) : // A -> B or A
        (state == 2'b01) ? (in ? 2'b01 : 2'b10) : // B -> B or C
        (state == 2'b10) ? (in ? 2'b11 : 2'b00) : // C -> D or A
        (state == 2'b11) ? (in ? 2'b01 : 2'b10) : // D -> B or C
        2'b00; // Default to A

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // Reset to state A
        else
            state <= next_state;
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == 2'b11); // Output 1 only in state D

endmodule