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
    end else begin
        case (state)
            1'b0: state <= j;
            1'b1: state <= ~k;
            default: state <= 1'b0; // Default case for sanity
        endcase
    end
end

endmodule