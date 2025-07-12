module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    // Localparam for intermediate XOR result (self-documentation)
    localparam logic [0:0] dummy = 1'b0; // Placeholder to illustrate localparams can exist here if needed
    
    always @(*) begin
        // Compute XOR then AND with x
        // Using procedural assignment for behavioral clarity
        z = (x ^ y) & x;
    end
endmodule