module serial2parallel #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [DATA_WIDTH-1:0] dout_parallel,
    output reg dout_valid
);

reg [DATA_WIDTH-1:0] shift_reg; // Shift register to store serial input data bits
reg [$clog2(DATA_WIDTH)-1:0] cnt; // Counter to keep track of the number of bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= {DATA_WIDTH{1'b0}};
        cnt <= '0;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        shift_reg <= {din_serial, shift_reg[DATA_WIDTH-1:1]}; // Shift in the new bit
        cnt <= (cnt == DATA_WIDTH-1) ? '0 : cnt + 1'b1; // Increment the counter
        if (cnt == DATA_WIDTH-1) begin
            dout_parallel <= shift_reg; // Update the parallel output data
            dout_valid <= 1'b1; // Set the output valid signal to 1
        end else begin
            dout_valid <= 1'b0; // Reset the output valid signal
        end
    end else begin
        dout_valid <= 1'b0; // Reset the output valid signal
    end
end

endmodule