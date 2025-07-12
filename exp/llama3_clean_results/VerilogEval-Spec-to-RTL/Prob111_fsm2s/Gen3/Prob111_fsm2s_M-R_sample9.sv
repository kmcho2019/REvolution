module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the states
enum {OFF, ON} state;

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        unique case(state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
        endcase
    end
end

endmodule