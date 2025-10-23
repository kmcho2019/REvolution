module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

    // Initialize the register q to 0
    initial q = 8'b0;

    // Define the combinational logic to generate the next state
    wire [7:0] next_q;
    assign next_q = {d, q[7:1]};

    // Instantiate a D Flip-Flop to store the state
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule