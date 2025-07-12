module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

    // Internal feedback signal
    reg feedback;

    // Calculate the feedback signal
    assign feedback = ~(out[3] ^ out[2]);

    // Synchronize the shifting operation with the clock
    always @(posedge clk) begin
        if (rst) begin
            // Reset the register to zero on the rising edge of the clock
            out <= 4'b0000;
        end else begin
            // Shift the register left and insert the new feedback value at the LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule