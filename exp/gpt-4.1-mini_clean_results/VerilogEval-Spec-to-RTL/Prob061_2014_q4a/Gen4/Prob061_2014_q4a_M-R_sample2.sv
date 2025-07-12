module TopModule (
    input  logic clk,
    input  logic w,
    input  logic R,
    input  logic E,
    input  logic L,
    output logic Q
);

    always_ff @(posedge clk) begin
        Q <= L ? R : (E ? w : Q);
    end

endmodule