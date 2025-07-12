module TopModule(
    input  logic in,
    output logic out
);
    logic constant_val;
    assign constant_val = 1'b0; // Default constant value, not used in this scenario
    assign out = in; // Direct assignment as per requirement, multiplexer idea not needed for this case
    // Example of how a multiplexer could be used if needed in the future:
    // assign out = (select_signal) ? in : constant_val;
endmodule