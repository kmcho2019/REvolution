// Module TopModule: An alternative implementation using a 2-to-1 multiplexer.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Internal signals
logic mux_out;  // Output of the multiplexer
logic const_zero = 1'b0;  // Constant input to the MUX
logic const_select = 1'b1;  // Control signal to always select 'in'

// 2-to-1 Multiplexer
always_comb begin
    case (const_select)
        1'b0: mux_out = const_zero;  // Select constant zero when control is 0
        1'b1: mux_out = in;  // Select input 'in' when control is 1
        default: mux_out = 1'bx;  // Default to undefined for invalid control
    endcase
end

// Assign the output of the MUX to the 'out' port
assign out = mux_out;

endmodule