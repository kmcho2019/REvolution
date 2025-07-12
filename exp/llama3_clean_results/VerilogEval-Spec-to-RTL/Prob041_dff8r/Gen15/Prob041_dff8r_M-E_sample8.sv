// Define a parameterizable parallel load module
module ParallelLoad #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] reg_bank1;
logic [WIDTH-1:0] reg_bank2;
logic [WIDTH-1:0] current_data;

always_ff @(posedge clk) begin
    if (reset) begin
        reg_bank1 <= {WIDTH{1'b0}};
        reg_bank2 <= {WIDTH{1'b0}};
    end else begin
        reg_bank1 <= reg_bank2;
        reg_bank2 <= d;
    end
end

always_comb begin
    current_data = reg_bank1;
end

assign q = current_data;

endmodule

// Instantiate the parallel load module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

ParallelLoad #(.WIDTH(8)) parallel_load(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule