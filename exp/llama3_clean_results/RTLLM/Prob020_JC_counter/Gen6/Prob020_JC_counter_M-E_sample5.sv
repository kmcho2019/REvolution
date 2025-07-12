module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Define the number of sections and bits per section
localparam NUM_SECTIONS = 8;
localparam BITS_PER_SECTION = 8;

// Generate the section updaters
genvar i;
generate
    for (i = 0; i < NUM_SECTIONS; i++) begin
        // Instantiate a section updater for each section
        section_updater su(
            .clk(clk),
            .rst_n(rst_n),
            .q_in((i == 0) ? 1'b0 : Q[(i-1)*BITS_PER_SECTION + BITS_PER_SECTION - 1]), // Next bit from previous section
            .lsb(Q[0]), // Least significant bit of the counter
            .q_out(Q[i*BITS_PER_SECTION +: BITS_PER_SECTION]) // Output of this section
        );
    end
endgenerate

endmodule

// Section updater module
module section_updater(
    input clk,
    input rst_n,
    input q_in, // Next bit from previous section (if applicable)
    input lsb, // Least significant bit of the counter
    output reg [7:0] q_out // Output of this section
);

// Update the section based on the least significant bit and the next bit
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set q_out to 0.
        q_out <= 8'd0;
    end else begin
        // If the least significant bit is 0, shift right and append 1.
        // If the least significant bit is 1, shift right and append 0.
        q_out <= (lsb == 1'b0) ? {1'b1, q_out[7:1]} : {1'b0, q_out[7:1]};
    end
end

endmodule