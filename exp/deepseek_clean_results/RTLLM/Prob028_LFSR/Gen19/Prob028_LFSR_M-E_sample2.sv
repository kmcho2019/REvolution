module LFSR (
    input req,        // Request input for handshaking
    output ack,       // Acknowledge output
    output reg [3:0] out
);

reg [1:0] tap_sel;    // Rotating tap selector
reg initialized;      // Power-on initialization flag
wire feedback;

// Dynamic feedback selection
assign feedback = ~(out[tap_sel[1]+2] ^ out[tap_sel[0]]);

// Acknowledge generation
assign ack = req && initialized;

always @(*) begin
    if (!initialized) begin
        out = 4'b0001;
    end
end

always @(posedge req) begin
    if (!initialized) begin
        initialized <= 1'b1;
        tap_sel <= 2'b00;
    end else begin
        // Update state and rotate taps
        out <= {out[2:0], feedback};
        tap_sel <= tap_sel + 1;
    end
end

endmodule