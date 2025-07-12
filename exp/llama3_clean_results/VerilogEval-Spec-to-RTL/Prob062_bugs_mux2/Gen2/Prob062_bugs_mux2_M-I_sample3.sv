module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output logic [7:0] out // Declare out as a logic type for assignment
);

    always @(*) // Use always @(*) for combinational logic
    begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // Handle unknown or high-Z cases
        endcase
    end

endmodule