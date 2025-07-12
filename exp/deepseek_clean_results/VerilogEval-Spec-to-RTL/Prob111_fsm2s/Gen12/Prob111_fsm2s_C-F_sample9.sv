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
                (state == ON) ? ~k : // ON state transition logic
                j;                  // OFF state transition logic
    end

    // Output depends only on current state (Moore)
    assign out = state;

endmodule