module TopModule (
    input [2:0] vec,
    output reg [2:0] outv,
    output reg o2, o1, o0,
    input clk,    // Added clock input for shift register
    input load    // Added load control
);

    always @(posedge clk) begin
        if (load) begin
            outv <= vec;        // Parallel load
            {o2, o1, o0} <= vec; // Also load individual bits
        end
        else begin
            // Shift operation (though not used here)
            {o2, o1, o0} <= {o1, o0, 1'b0};
        end
    end

endmodule