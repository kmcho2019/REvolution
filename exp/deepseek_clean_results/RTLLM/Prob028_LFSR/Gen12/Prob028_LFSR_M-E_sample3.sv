module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Configuration and internal signals
reg [1:0] poly_sel = 2'b00;  // Feedback polynomial selector
reg [3:0] watchdog;           // Watchdog counter
wire feedback;

// Feedback polynomial options
wire poly0 = ~(out[3] ^ out[2]);  // Required inverted feedback
wire poly1 = out[3] ^ out[1];     // Alternative polynomial 1
wire poly2 = out[3] ^ out[0];     // Alternative polynomial 2

// Feedback selection mux
assign feedback = (poly_sel == 2'b00) ? poly0 :
                 (poly_sel == 2'b01) ? poly1 : poly2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001;           // Initialize to non-zero
        watchdog <= 4'b0000;
        poly_sel <= 2'b00;        // Default to required mode
    end else begin
        watchdog <= watchdog + 1;
        
        // Automatic reseed after 15 cycles
        if (&watchdog) begin
            out <= {out[0], out[3:1]};  // Rotate current state
            poly_sel <= poly_sel + 1;   // Cycle to next polynomial
        end else begin
            // Normal LFSR operation
            out <= {out[2:0], feedback};
        end
        
        // Safety: if we somehow reach zero, force reseed
        if (out == 4'b0000) begin
            out <= 4'b0001;
            poly_sel <= 2'b00;
        end
    end
end

endmodule