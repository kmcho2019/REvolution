module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg state_z;

    assign z = state_z;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state_z <= 0;              // BEFORE_FIRST_ONE state and output=0
        else
            state_z <= state_z ? ~x : x; 
            // if in AFTER_FIRST_ONE (state_z=1), output is ~x; else output is x
            // also state transitions: once state_z=1, it stays 1
    end

endmodule