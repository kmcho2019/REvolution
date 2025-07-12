module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg [1:0] state;  // one-hot: OFF=01, ON=10
    
    // Next state logic
    wire [1:0] next_state;
    assign next_state[0] = (~state[1] & ~j) | (state[1] & k);  // OFF stays or ON->OFF
    assign next_state[1] = (~state[1] & j) | (state[1] & ~k);  // OFF->ON or ON stays
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to OFF
        end else begin
            state <= next_state;
        end
    end
    
    assign out = state[1];  // ON state is when second bit is high
endmodule