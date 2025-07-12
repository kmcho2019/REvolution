module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // 0: below s[0], 1: between s[0] and s[1], 2: between s[1] and s[2], 3: above s[2]
reg [1:0] prev_state;

// Compute the current state based on the sensor inputs
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state below s[0]
        prev_state <= 2'b00;
    end else begin
        case ({s[2], s[1], s[0]})
            3'b000: state <= 2'b00; // Below s[0]
            3'b001, 3'b010, 3'b011: state <= 2'b01; // Between s[0] and s[1]
            3'b100, 3'b101: state <= 2'b10; // Between s[1] and s[2]
            3'b110, 3'b111: state <= 2'b11; // Above s[2]
        endcase

        // Update prev_state
        prev_state <= state;
    end
end

// Compute the output values based on the current state
assign fr2 = (state == 2'b00) ? 1'b1 : 1'b0;
assign fr1 = (state == 2'b00 || state == 2'b01) ? 1'b1 : 1'b0;
assign fr0 = (state != 2'b11) ? 1'b1 : 1'b0;

// Update dfr based on the state transition
always @(posedge clk) begin
    if (reset) begin
        dfr <= 1'b1;
    end else begin
        case (state)
            2'b00: dfr <= 1'b0;
            2'b01: dfr <= (prev_state == 2'b00) ? 1'b1 : 1'b0;
            2'b10: dfr <= (prev_state == 2'b01) ? 1'b1 : 1'b0;
            2'b11: dfr <= 1'b0;
        endcase
    end
end

endmodule