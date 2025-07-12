module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    reg [2:0] state;

    // Decode current state bits for clarity
    wire s0 = (state == 3'b000);
    wire s1 = (state == 3'b001);
    wire s2 = (state == 3'b010);
    wire s3 = (state == 3'b011);
    wire s4 = (state == 3'b100);

    // Combinational next state logic via assign statements using ternaries
    wire [2:0] next_state = (reset) ? 3'b000 : 
        {   // bit2
            (s1 & x) | (s4 & ~x), 
            // bit1
            (s3 & x) | (s4 & x) | (s3 & ~x), 
            // bit0
            (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x)
        };

    always @(posedge clk) begin
        state <= next_state;
    end

    // Output combinationally based on state
    assign z = s3 | s4;

endmodule