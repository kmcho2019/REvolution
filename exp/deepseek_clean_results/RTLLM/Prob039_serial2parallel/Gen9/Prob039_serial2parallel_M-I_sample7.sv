module serial2parallel #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [WIDTH-1:0] dout_parallel,
    output reg dout_valid
);

    localparam CNT_WIDTH = $clog2(WIDTH);
    reg [CNT_WIDTH-1:0] bit_counter;

    // Clock gating logic for power optimization
    wire shift_enable = din_valid;
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= {WIDTH{1'b0}};
            dout_parallel <= {WIDTH{1'b0}};
            dout_valid    <= 1'b0;
            bit_counter   <= {CNT_WIDTH{1'b0}};
        end else begin
            // Default outputs
            dout_valid <= 1'b0;

            if (shift_enable) begin
                // Shift in new bit at LSB
                shift_reg <= {shift_reg[WIDTH-2:0], din_serial};

                // Increment counter
                if (bit_counter == WIDTH-1) begin
                    bit_counter   <= {CNT_WIDTH{1'b0}};
                    dout_parallel <= shift_reg; // Capture parallel output
                    dout_valid    <= 1'b1;     // Pulse valid for one cycle
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

endmodule