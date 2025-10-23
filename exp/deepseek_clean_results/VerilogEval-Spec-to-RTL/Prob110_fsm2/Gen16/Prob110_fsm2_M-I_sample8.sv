module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    // Combined state register and transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) state <= 0;
        else state <= state ? ~k : j;
    end
    
    // Output logic (Moore style)
    assign out = state;
endmodule