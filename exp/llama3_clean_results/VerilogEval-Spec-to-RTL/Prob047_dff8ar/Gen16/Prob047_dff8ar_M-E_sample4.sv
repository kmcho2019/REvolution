// Single-port RAM module with active high asynchronous reset
module RAM(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] ram[0:0]; // Single-port RAM with 1 location

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ram[0] <= 8'b0;
        end else begin
            ram[0] <= d;
        end
    end

    assign q = ram[0];

endmodule

// TopModule with a single-port RAM
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    RAM ram_module(.clk(clk),.areset(areset),.d(d),.q(q));

endmodule