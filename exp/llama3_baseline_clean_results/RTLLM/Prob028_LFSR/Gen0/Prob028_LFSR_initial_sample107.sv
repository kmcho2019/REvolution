module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

    // Calculate the feedback signal
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the LFSR to zero
            out <= 4'd0;
        end else begin
            // Shift the current state left and insert the new feedback value at the LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule