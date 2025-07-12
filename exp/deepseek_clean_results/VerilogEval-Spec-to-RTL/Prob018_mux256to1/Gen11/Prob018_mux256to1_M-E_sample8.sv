module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Recursive function to build binary tree mux
    function automatic logic mux_tree(input [255:0] data, input [7:0] sel);
        if ($bits(data) == 1) begin
            return data;
        end else begin
            logic [($bits(data)/2)-1:0] upper_half, lower_half;
            upper_half = data[$bits(data)-1 : $bits(data)/2];
            lower_half = data[($bits(data)/2)-1 : 0];
            return sel[0] ? mux_tree(upper_half, sel >> 1) : mux_tree(lower_half, sel >> 1);
        end
    endfunction

    assign out = mux_tree(in, sel);

endmodule