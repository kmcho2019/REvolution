module TopModule (
    input        clk,
    input        reset,
    input        slowena,
    output reg [3:0] q
);

// One-hot ring counter state: 10 bits, only one bit '1' at a time.
reg [9:0] ring_state;
wire [9:0] next_ring_state;

// Generate next state: rotate left by 1 bit when enabled
assign next_ring_state = {ring_state[8:0], ring_state[9]};

always @(posedge clk) begin
    if (reset) begin
        // Initialize with bit 0 set (count = 0)
        ring_state <= 10'b0000000001;
    end else if (slowena) begin
        ring_state <= next_ring_state;
    end
    // else hold current state
end

// Priority encoder to convert one-hot ring_state to binary count q
always @(*) begin
    casez (ring_state)
        10'b0000000001 : q = 4'd0;
        10'b0000000010 : q = 4'd1;
        10'b0000000100 : q = 4'd2;
        10'b0000001000 : q = 4'd3;
        10'b0000010000 : q = 4'd4;
        10'b0000100000 : q = 4'd5;
        10'b0001000000 : q = 4'd6;
        10'b0010000000 : q = 4'd7;
        10'b0100000000 : q = 4'd8;
        10'b1000000000 : q = 4'd9;
        default        : q = 4'd0; // Safe default in case of error
    endcase
end

endmodule