module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output wire [3:0] out
);

// One-hot state encoding (12 states)
reg [11:0] state;

// Output decoder (combinational)
assign out = 
    (state[0]) ? 4'd0 :
    (state[1]) ? 4'd1 :
    (state[2]) ? 4'd2 :
    (state[3]) ? 4'd3 :
    (state[4]) ? 4'd4 :
    (state[5]) ? 4'd5 :
    (state[6]) ? 4'd6 :
    (state[7]) ? 4'd7 :
    (state[8]) ? 4'd8 :
    (state[9]) ? 4'd9 :
    (state[10]) ? 4'd10 :
    4'd11; // state[11]

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 12'b0000_0000_0001; // Reset to state 0
    end
    else if (valid_count) begin
        // Circular shift left with wrap-around
        state <= {state[10:0], state[11]};
    end
    // else hold current state
end

endmodule