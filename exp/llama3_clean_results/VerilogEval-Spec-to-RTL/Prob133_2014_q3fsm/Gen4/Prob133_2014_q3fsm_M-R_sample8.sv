module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 1-bit state variable (0: State A, 1: State B)
reg [1:0] window_counter; // 2-bit counter for three clock cycles
reg [1:0] w_count; // 2-bit signal to track w = 1 occurrences

// Combinational logic for next state
assign next_state = (state == 1'b0 && s) ? 1'b1 : state;

// Combinational logic for window counter
assign next_window_counter = (window_counter == 2'b11) ? 2'b00 : (state == 1'b1) ? window_counter + 1'b1 : 2'b00;

// Combinational logic for w count
assign next_w_count = (window_counter == 2'b00 && state == 1'b1) ? w : 
                      (window_counter == 2'b01 && state == 1'b1) ? w_count + w : 
                      (window_counter == 2'b10 && state == 1'b1) ? w_count + w : 
                      (window_counter == 2'b11 && state == 1'b1) ? w_count : w_count;

// Combinational logic for output z
assign next_z = (window_counter == 2'b11 && state == 1'b1 && w_count == 2'b10) ? 1'b1 : 1'b0;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // Reset to state A
        window_counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        state <= next_state;
        window_counter <= next_window_counter;
        w_count <= next_w_count;
        z <= next_z;
    end
end

endmodule