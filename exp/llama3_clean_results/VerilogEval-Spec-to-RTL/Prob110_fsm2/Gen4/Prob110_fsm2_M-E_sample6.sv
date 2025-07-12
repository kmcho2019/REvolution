module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state

// Define states as enumerations
`define OFF 1'b0
`define ON  1'b1

// Asynchronous reset and synchronous next-state logic using LUT approach
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `OFF;
        out <= `OFF;
    end else begin
        case ({state, j, k})
            3'b000: begin state <= `OFF; out <= `OFF; end
            3'b001: begin state <= `OFF; out <= `OFF; end
            3'b010: begin state <= `ON;  out <= `OFF; end
            3'b011: begin state <= `ON;  out <= `OFF; end
            3'b100: begin state <= `ON;  out <= `ON; end
            3'b101: begin state <= `OFF; out <= `ON; end
            3'b110: begin state <= `ON;  out <= `ON; end
            3'b111: begin state <= `OFF; out <= `ON; end
            default: begin state <= `OFF; out <= `OFF; end
        endcase
    end
end

endmodule