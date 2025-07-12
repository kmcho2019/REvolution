module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register for FSM
reg prev_data_in; // Store previous value of data_in

// Combinational logic for next state
wire next_state_0 = (~rst_n) ? 0 : (state == 0 && data_in && !prev_data_in) ? 1 : 
                     (state == 1 && !data_in && prev_data_in) ? 2 : 
                     (state == 2) ? 0 : state;

// Combinational logic for data_out
wire data_out_comb = (state == 1 && !data_in && prev_data_in);

// Sequential logic for state update and data_out
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0; // Reset state to initial
        data_out <= 0; // Reset output
        prev_data_in <= 0; // Reset previous data_in
    end else begin
        state <= next_state_0; // Update state
        data_out <= data_out_comb; // Update data_out
        prev_data_in <= data_in; // Update previous data_in
    end
end

endmodule