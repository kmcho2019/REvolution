module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Define the number of processing elements (PEs) in the systolic array
localparam NUM_PES = 512;

// Define the width of each PE's input and output
localparam PE_WIDTH = 1;

// Define the systolic array
wire [NUM_PES-1:0] pe_out;

// Generate the PEs in the systolic array
genvar i;
generate
    for (i = 0; i < NUM_PES; i++) begin
        // Instantiate the PE
        PE pe_inst (
            .clk(clk),
            .load(load),
            .in_left((i == 0) ? 1'b0 : q_reg[i-1]),
            .in_center(q_reg[i]),
            .in_right((i == NUM_PES-1) ? 1'b0 : q_reg[i+1]),
            .out(pe_out[i])
        );
    end
endgenerate

// Update the register with the output of the PEs
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= pe_out;
    end
end

assign q = q_reg;

// Define the PE module
module PE (
    input clk,
    input load,
    input in_left,
    input in_center,
    input in_right,
    output out
);

reg out_reg;

// Update the output register
always @(posedge clk) begin
    if (load) begin
        out_reg <= in_center; // Initialize with the center value
    end else begin
        out_reg <= in_left ^ in_right; // Apply Rule 90 logic
    end
end

assign out = out_reg;

endmodule

endmodule