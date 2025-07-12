module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;  // state[1] = previous state, state[0] = current state

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new data
        state <= {state[0], data_in};
        
        // Registered output for better timing
        data_out <= (~state[1] & state[0] & ~data_in);
    end
end

endmodule