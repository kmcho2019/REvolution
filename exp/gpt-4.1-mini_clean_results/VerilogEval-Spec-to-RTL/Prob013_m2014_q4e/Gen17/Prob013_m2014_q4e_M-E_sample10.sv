module TopModule (
    input  wire in1,
    input  wire in2,
    output reg  out
);
    // Behavioral combinational logic for 2-input NOR gate
    always @(*) begin
        out <= ~(in1 | in2);
    end
endmodule