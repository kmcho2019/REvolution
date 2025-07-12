module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Recursive function to build binary tree mux
    function automatic logic mux_tree;
        input [255:0] data;
        input [7:0] select;
        begin
            if ($bits(data) == 1) begin
                mux_tree = data;
            end else begin
                logic [($bits(data)/2)-1:0] upper, lower;
                upper = data[$bits(data)-1 : $bits(data)/2];
                lower = data[($bits(data)/2)-1 : 0];
                mux_tree = select[$clog2($bits(data))-1] ? 
                           mux_tree(upper, select) : 
                           mux_tree(lower, select);
            end
        end
    endfunction

    assign out = mux_tree(in, sel);

endmodule