module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// State variable
logic state;

// Next state logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0;
    end else begin
        state <= (state == 0 && j) || (state == 1 && ~k);
    end
end

// Output assignment based on state
assign out = state;

endmodule