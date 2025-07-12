module CircularRegister #(parameter WIDTH = 8) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= {WIDTH{1'b0}};
        end else begin
            // Circular shift with parallel load
            q <= {d[0], d[WIDTH-1:1]};
        end
    end
endmodule

module TopModule #(parameter WIDTH = 8) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    // The circular register behaves like DFFs when we feed the input back
    // through the circular path on each clock edge
    wire [WIDTH-1:0] parallel_input = reset ? {WIDTH{1'b0}} : d;
    
    CircularRegister #(.WIDTH(WIDTH)) reg_inst (
        .clk(clk),
        .reset(1'b0), // Reset handled in the parallel input mux
        .d(parallel_input),
        .q(q)
    );
endmodule