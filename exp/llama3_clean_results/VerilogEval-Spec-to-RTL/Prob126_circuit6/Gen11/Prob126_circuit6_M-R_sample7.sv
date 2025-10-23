module TopModule(
    input [2:0] a,
    output [15:0] q
);

reg [15:0] outputs [7:0]; // Array to store output values

// Initialize the output values
initial begin
    outputs[0] = 16'h1232; // Output for a = 0
    outputs[1] = 16'haee0; // Output for a = 1
    outputs[2] = 16'h27d4; // Output for a = 2
    outputs[3] = 16'h5a0e; // Output for a = 3
    outputs[4] = 16'h2066; // Output for a = 4
    outputs[5] = 16'h64ce; // Output for a = 5
    outputs[6] = 16'hc526; // Output for a = 6
    outputs[7] = 16'h2f19; // Output for a = 7
end

// Use a casez statement to select the correct output based on 'a'
assign q = outputs[a];

endmodule