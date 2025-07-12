// Define the TopModule with the SIPO and PIPO registers
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Define the serial-in, parallel-out (SIPO) shift register
logic [7:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= {8{1'b0}};
    end else begin
        shift_reg <= {d[0], shift_reg[7:1]};
    end
end

// Define the parallel-in, parallel-out (PIPO) register
logic [7:0] pipo_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        pipo_reg <= {8{1'b0}};
    end else begin
        pipo_reg <= shift_reg;
    end
end

// Assign the output
assign q = pipo_reg;

endmodule