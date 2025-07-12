// Load Module: Loads data into the register
module LoadModule(
    input           clk,      // Clock signal
    input           load,     // Load signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end
end

assign q = q_reg;

endmodule

// Shift Module: Performs shift operation on the register
module ShiftModule(
    input           clk,      // Clock signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (ena) begin
        q_reg <= {1'b0, q_reg[3:1]};
    end
end

assign q = q_reg;

endmodule

// Main Module: Orchestrates load and shift operations
module TopModule(
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

wire [3:0] load_out;
wire [3:0] shift_out;

LoadModule load_module(
    .clk(clk),
    .load(load),
    .data(data),
    .q(load_out)
);

ShiftModule shift_module(
    .clk(clk),
    .ena(ena),
    .data(load_out),
    .q(shift_out)
);

reg [3:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else if (load) begin
        q_reg <= load_out;
    end else if (ena) begin
        q_reg <= shift_out;
    end
end

assign q = q_reg;

endmodule