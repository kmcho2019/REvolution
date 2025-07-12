module LFSR (
    input clk,
    input rst,
    output reg [3:0] out,  // Current state output
    output reg ready       // New signal indicating valid output
);

reg [1:0] fb_sel;         // Feedback configuration selector
reg [3:0] seed_counter;   // Internal seed generator
wire feedback;            // Feedback signal

// Configurable feedback path
assign feedback = (fb_sel == 2'b00) ? ~(out[3] ^ out[2]) :  // XNOR of bits 3,2
                  (fb_sel == 2'b01) ? ~(out[3] ^ out[1]) :  // XNOR of bits 3,1
                  (fb_sel == 2'b10) ? ~(out[3] ^ out[0]) :  // XNOR of bits 3,0
                                      ~(out[3] ^ out[2] ^ out[1] ^ out[0]); // Multi-tap

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;
        ready <= 1'b0;
        seed_counter <= 4'b0000;
        fb_sel <= 2'b00;
    end
    else begin
        if (out == 4'b0000) begin
            // Auto-reseed when state becomes all zeros
            out <= seed_counter + 1;
            seed_counter <= seed_counter + 1;
            fb_sel <= fb_sel + 1;  // Change feedback config
            ready <= 1'b0;
        end
        else begin
            // Normal LFSR operation
            out <= {out[2:0], feedback};
            ready <= 1'b1;
        end
    end
end

endmodule