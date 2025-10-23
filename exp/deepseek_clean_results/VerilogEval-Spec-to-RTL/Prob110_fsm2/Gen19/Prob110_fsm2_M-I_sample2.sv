module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    // State transition with case statement
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= 0;
        else begin
            case (state)
                0: state <= j;  // OFF state transitions
                1: state <= ~k; // ON state transitions
            endcase
        end
    end
    
    // Moore output
    assign out = state;
endmodule