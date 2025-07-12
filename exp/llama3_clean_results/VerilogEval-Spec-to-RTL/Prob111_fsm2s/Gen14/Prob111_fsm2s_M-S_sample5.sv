module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the state
logic state;

// Output logic
assign out = state;

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 1'b0;
    end else if (state == 1'b0) begin
        state <= j;
    end else begin
        state <= ~k;
    end
end

endmodule