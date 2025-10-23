module SmartRegister #(
    parameter WIDTH = 8,
    parameter RESET_VALUE = 8'h00,
    parameter ENABLE_CLOCK_GATING = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q,
    // Optional debug ports
    output serial_out,
    input test_mode,
    input shift_enable
);

    reg [WIDTH-1:0] data_reg;
    wire gated_clk;
    reg [WIDTH-1:0] prev_d;
    wire data_stable;
    wire clock_enable;

    // Clock gating logic
    assign data_stable = (d == prev_d);
    assign clock_enable = ~(ENABLE_CLOCK_GATING && (reset || data_stable));
    assign gated_clk = clk & clock_enable;

    // Main register with dual functionality
    always @(posedge gated_clk) begin
        prev_d <= d;
        if (reset) begin
            data_reg <= RESET_VALUE;
        end else if (test_mode) begin
            if (shift_enable) begin
                data_reg <= {data_reg[WIDTH-2:0], data_reg[WIDTH-1]};
            end
        end else begin
            data_reg <= d;
        end
    end

    // Output assignments
    assign q = data_reg;
    assign serial_out = data_reg[0];  // LSB for serial output

    // Stability checker
    always @(posedge clk) begin
        if (reset) begin
            prev_d <= RESET_VALUE;
        end else begin
            prev_d <= d;
        end
    end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate the smart register with default configuration
    SmartRegister #(
        .WIDTH(8),
        .RESET_VALUE(8'h00),
        .ENABLE_CLOCK_GATING(1)
    u_smart_reg (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q),
        .serial_out(),      // Leave unconnected
        .test_mode(1'b0),   // Normal operation
        .shift_enable(1'b0) // No shifting
    );

endmodule