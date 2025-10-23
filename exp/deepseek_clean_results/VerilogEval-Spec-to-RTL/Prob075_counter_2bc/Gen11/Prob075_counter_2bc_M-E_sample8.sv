module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Bit-level control signals
wire update_en = train_valid;
wire inc = train_taken;
wire dec = ~train_taken;

// Individual bit update logic
wire lsb_toggle = update_en & ((inc & ~state[1]) | (dec & state[1]));
wire msb_toggle = update_en & ((inc & state[0]) | (dec & ~state[0]));

// Sequential bit registers
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state[1] <= 1'b0;  // MSB
        state[0] <= 1'b1;  // LSB
    end else begin
        if (lsb_toggle) state[0] <= ~state[0];
        if (msb_toggle) state[1] <= ~state[1];
    end
end

endmodule