module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Function to optionally reverse bits (disabled by default)
    function [7:0] process_byte;
        input [7:0] data;
        input reverse;
        begin
            process_byte = reverse ? {data[0], data[1], data[2], data[3],
                                    data[4], data[5], data[6], data[7]} : data;
        end
    endfunction

    // Parameters for configuration
    parameter REVERSE_BITS = 0;  // Set to 1 to enable bit reversal

    // Process each byte (with reversal disabled by default)
    assign out_hi = process_byte(in[15:8], REVERSE_BITS);
    assign out_lo = process_byte(in[7:0], REVERSE_BITS);

endmodule