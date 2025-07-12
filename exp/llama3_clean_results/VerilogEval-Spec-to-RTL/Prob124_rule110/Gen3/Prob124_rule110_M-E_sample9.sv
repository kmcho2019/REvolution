module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Lookup table for Rule 110
reg [0:7] lut = '{
    8'b00000000, // 000
    8'b00000000, // 001
    8'b00000000, // 010
    8'b00000001, // 011
    8'b00000001, // 100
    8'b00000001, // 101
    8'b00000001, // 110
    8'b00000000  // 111
};

integer i;

always @(*) begin
    for (i = 0; i < 512; i++) begin
        reg [2:0] neighbor_states;
        if (i == 0) begin
            neighbor_states = {1'b0, current_state[i], i == 511 ? 1'b0 : current_state[i + 1]};
        end else if (i == 511) begin
            neighbor_states = {current_state[i - 1], current_state[i], 1'b0};
        end else begin
            neighbor_states = {current_state[i - 1], current_state[i], current_state[i + 1]};
        end
        next_state[i] = lut[neighbor_states];
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule