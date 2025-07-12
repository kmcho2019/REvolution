module TopModule (
    input  wire clk,
    input  wire d,
    input  wire q  // This is unusual for a DFF but included as per spec
);

    // Internal reg for DFF output, shadowing the input q
    reg q_reg = 1'b0;

    // Assign output port q to internal reg q_reg
    // Note: 'q' is declared as input in interface but typically should be output,
    // here we assume bidirectional or test purpose; to comply, we do nothing for the input q port.
    // For demonstration, the internal registered value is exposed only internally.
    // If q port is indeed output, the interface should be corrected, or use another signal for output.

    always @(posedge clk) begin
        q_reg <= d;
    end

endmodule