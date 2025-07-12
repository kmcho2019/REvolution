module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg state;  // Stores current state (OFF or ON)

    always @(posedge clk) begin
        state <= reset ? OFF :       // Synchronous reset
                 state ? ~k : j;    // State transition logic
    end

    assign out = state;  // Moore output

endmodule