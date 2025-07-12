module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_register;

// Clock gating logic to reduce power consumption when the module is idle
// This example assumes an enable signal is available; in practice, this signal
// would need to be generated based on the system's requirements.
wire clk_gated;
assign clk_gated = clk && enable; // Assuming 'enable' is a signal indicating the module should be active

always @(posedge clk_gated or negedge resetn) begin
    if (!resetn) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= {in, shift_register[3:1]};
    end
end

assign out = shift_register[0];

// Example of how the enable signal might be generated based on system requirements
// This is a placeholder and would need to be adapted to the actual system.
reg enable;
always @(posedge clk) begin
    if (!resetn) begin
        enable <= 1'b0; // Reset enable to inactive state
    end else if (some_system_condition) begin
        enable <= 1'b1; // Set enable to active state based on some system condition
    end else begin
        enable <= 1'b0; // Otherwise, keep enable inactive
    end
end

endmodule