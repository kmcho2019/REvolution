module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg [1:0] state; // one-hot encoding: state[0]=OFF, state[1]=ON
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Reset to OFF state
        end else begin
            case (state)
                2'b01: state <= j ? 2'b10 : 2'b01; // OFF state transitions
                2'b10: state <= k ? 2'b01 : 2'b10; // ON state transitions
                default: state <= 2'b01; // Handle illegal states
            endcase
        end
    end
    
    assign out = state[1]; // Output is ON state bit
endmodule