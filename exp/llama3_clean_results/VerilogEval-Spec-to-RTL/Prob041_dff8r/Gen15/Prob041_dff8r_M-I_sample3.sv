// Define a parameterizable shift register module
module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= {WIDTH{1'b0}};
    end else begin
        // Add clock enable signal to reduce power consumption
        if (d != shift_reg) begin
            shift_reg <= d;
        end
    end
end

assign q = shift_reg;

endmodule

// Instantiate the shift register module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Add clock enable signal
logic clk_en;

// Use a low-power library for the flip-flops (if available)
// For demonstration purposes, assume a low-power library is available
// and the module name is "LowPowerShiftRegister"
LowPowerShiftRegister #(.WIDTH(8)) shift_reg(
    .clk(clk),
    .clk_en(clk_en),
    .reset(reset),
    .d(d),
    .q(q)
);

// Generate clock enable signal
always_comb begin
    // Enable clock only when input data changes
    if (d != q) begin
        clk_en = 1'b1;
    end else begin
        clk_en = 1'b0;
    end
end

endmodule

// Define a low-power shift register module (for demonstration purposes)
module LowPowerShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input clk_en,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] shift_reg;

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (reset) begin
            shift_reg <= {WIDTH{1'b0}};
        end else begin
            shift_reg <= d;
        end
    end
end

assign q = shift_reg;

endmodule