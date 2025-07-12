module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg state;  // OFF or ON

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= (state) ? ~k : j;
    end

    assign out = state;

endmodule