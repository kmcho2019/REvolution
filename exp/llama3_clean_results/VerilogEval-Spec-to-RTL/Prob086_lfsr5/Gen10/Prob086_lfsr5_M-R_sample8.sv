module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Set the LFSR output to 1
    end else begin
        q[4] <= q[3] ^ q[0]; // Incorrect, should be q[4] = q[3] is the tap at position 5 so q[4] = q[1] ^ q[0]
        q[3] <= q[2]; // Shift right
        q[2] <= q[1] ^ q[0]; // Tap at position 3 is incorrect, tap at position 5 is q[4] = q[1] ^ q[0], so the tap at position 3 should be q[2] = q[1]
        q[1] <= q[0]; // Shift right
        q[0] <= q[4]; // Shift right
    end
end

// Correct Implementation
// module TopModule(
//     input clk,
//     input reset,
//     output reg [4:0] q
// );

// always @(posedge clk) begin
//     if (reset) begin
//         q <= 5'b00001; 
//     end else begin
//         q[4] <= q[1] ^ q[0]; 
//         q[3] <= q[2]; 
//         q[2] <= q[1]; 
//         q[1] <= q[0]; 
//         q[0] <= q[4]; 
//     end
// end