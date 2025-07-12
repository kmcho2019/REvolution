module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a single bit to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        state <= (state == 0 && in == 0) ? 1 : 
                 (state == 0 && in == 1) ? 0 : 
                 (state == 1 && in == 0) ? 0 : 
                 (state == 1 && in == 1) ? 1 : state;
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule